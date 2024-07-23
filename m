Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40450156F29;
	Tue, 23 Jul 2024 18:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759285; cv=none; b=h4gRVrERsCNJTOOAxmHB47YRxGzWuaCMv8W8DTp9uLveoQhP0ZTvj0TPv6otEAA3JpWB4+8+SzmIxVyBKBY9pG2fa94y5Rdfw9RoiwIfuz/leY7SS2L1Sl/SlgamDWsZ8IEVAE19IBqhBuK/UNC2OYkJbthkkcwyW2J18uBxLBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759285; c=relaxed/simple;
	bh=8LPSiDZI/m2fBKDqzWJmeHIsZqPr3iNMErmQImxD27g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bITyT2Hn/S3AMFAIhFtt0fYXwI/A7oJixKo2loedJ9PJMvJX7LihvRnnC45hs7OJiXTxlkuXQmOFdmx+i/s4f7Jp8gQplH/X6JeZbOK9WiOeDBDjmmwV/nOXoH/Xo/e7Gd5t2uIie3eAovQ/C/oC3Is81ct7x2yokm37Asra67E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SpmgBmIt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpmgBmIt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93AEC4AF0A;
	Tue, 23 Jul 2024 18:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759285;
	bh=8LPSiDZI/m2fBKDqzWJmeHIsZqPr3iNMErmQImxD27g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SpmgBmItgrrdPTZn8/7+6WckYqazJfNecXFQ+6SE+xZkLDDFdzvTTBhaAxElYTlUX
	 37tyRgRpX5XkcK7bcuvJ8aDb6kwfF8CC8MTDKxNPPU+p8gTRsPap+If38siXg9ET4m
	 ivR0/e6OGRUcrwRovSbOYTfHAUgOrQ9h+JRKNJuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/105] kconfig: gconf: give a proper initial state to the Save button
Date: Tue, 23 Jul 2024 20:23:11 +0200
Message-ID: <20240723180404.549822646@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 17adabfd6e6bf..5d1404178e482 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -1481,7 +1481,6 @@ int main(int ac, char *av[])
 
 	conf_parse(name);
 	fixup_rootmenu(&rootmenu);
-	conf_read(NULL);
 
 	/* Load the interface and connect signals */
 	init_main_window(glade_file);
@@ -1489,6 +1488,8 @@ int main(int ac, char *av[])
 	init_left_tree();
 	init_right_tree();
 
+	conf_read(NULL);
+
 	switch (view_mode) {
 	case SINGLE_VIEW:
 		display_tree_part();
-- 
2.43.0



