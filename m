Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1A1FC18;
	Thu, 25 Jul 2024 14:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918870; cv=none; b=MePKncp5rkcOwghmJuTabmsmUojAu3xzmkH6utvneAEQ1Kp7ILy4Z0LQvwnqLC8I4D9uDJo0nN364n/DeW7VHpeZbI3CHNqrurT2X2uG74hzyzMG2PRudlWF1cenj3//gBcuI36uOdXn2Fgnpo4kjp28fRg4iYgSnzjlMLdveQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918870; c=relaxed/simple;
	bh=zDpu5z9TjqFZIJfFEy2o32jonIQVeWkZ+UZxmFA6SYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgJtPErpWEM0k7hd3lnram8jBdxpsG+tmvsRCGQacyKxmqidY95fmGjP+y/J4pVbsgNlJv0f9gtrko5LOjv2NYx3JkFjcXBMEjUHkDIslqICIFSYF/nS0t85yGfPhjdcdzsqfP8Z/EMvpj3P1GmTC0RQkM0r/gcQG20kvRvLje0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ONbjNJ/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ONbjNJ/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FD0C116B1;
	Thu, 25 Jul 2024 14:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918869;
	bh=zDpu5z9TjqFZIJfFEy2o32jonIQVeWkZ+UZxmFA6SYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ONbjNJ/UIKBafX+NT+vxzyFtahrJQNTvbsvkpUUyHdrQeZ1sKqemZTzKyKDW3sG6y
	 R0unbSYJH1YYASpd7m2l1phmMAPtXc1tTmwOh3WuM2k7Z8CyDvhYkRznYuBD0LMfH6
	 2lz0kKzfww7X9QuaqkcE5a8Ei9Ytifp/vTgszVbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 14/59] kconfig: gconf: give a proper initial state to the Save button
Date: Thu, 25 Jul 2024 16:37:04 +0200
Message-ID: <20240725142733.805505170@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 46edf4372e336ef3a61c3126e49518099d2e2e6d ]

Currently, the initial state of the "Save" button is always active.

If none of the CONFIG options are changed while loading the .config
file, the "Save" button should be greyed out.

This can be fixed by calling conf_read() after widget initialization.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/gconf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index 5527482c30779..4097999127315 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -1484,7 +1484,6 @@ int main(int ac, char *av[])
 
 	conf_parse(name);
 	fixup_rootmenu(&rootmenu);
-	conf_read(NULL);
 
 	/* Load the interface and connect signals */
 	init_main_window(glade_file);
@@ -1492,6 +1491,8 @@ int main(int ac, char *av[])
 	init_left_tree();
 	init_right_tree();
 
+	conf_read(NULL);
+
 	switch (view_mode) {
 	case SINGLE_VIEW:
 		display_tree_part();
-- 
2.43.0



