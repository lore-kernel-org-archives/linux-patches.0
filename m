Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC1D13D896;
	Tue, 23 Jul 2024 18:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760006; cv=none; b=kSeUUT57x4x+66EBkC1A05tNGUSrx2ya9IPM/KQoPxvyi+ojEuiUxw/oVJdA25/wsd46xmSQweFkjuTbojIlP+urlweHLAaZNh25PQ4cDAAxgrFyknPgRmXtCi9m6ueiioVFaGogm1I9DvV2Pfrl8TDR5TlK9c+PjYEXsxxk+aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760006; c=relaxed/simple;
	bh=3ITAyRB6bPwS7WdhAfTaP0Tq5p8BjDRl+cgfpnoyOr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYmr/5zDnuKxzs2MvGTl2GB9bNyclRemSG5c/5gcyAxLqYBbbCnPwzQMTCNW74jND+NItNderkk+X5eyTRCGvHYO93pId4RuYeCjY8gpLom9KfwIMxBNSqYE6qfBvJhW6Is6oez3E6uXhuA3ANzAIbVtytueOYCyuZfBG2bNXbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPbC3sOd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPbC3sOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369CFC4AF09;
	Tue, 23 Jul 2024 18:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760006;
	bh=3ITAyRB6bPwS7WdhAfTaP0Tq5p8BjDRl+cgfpnoyOr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DPbC3sOd4XR2DMLjK0KR1+/7kfbtaFiFa4ymBUj4gZS3AnKIUEXVs2rZmUlnyce1L
	 0WQWSXr5V++ijgp/PcerOlMcAlyHIc0YkG1hxxAiMA0JsU1tSVqpPMnoF7yEo4TN5a
	 BOUuqt3Rsty51RLz/KcDniIf+vf0CdzSfNWCWds8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 040/163] kconfig: gconf: give a proper initial state to the Save button
Date: Tue, 23 Jul 2024 20:22:49 +0200
Message-ID: <20240723180145.021989596@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 9709aca3a30fe..9e52c7360e55b 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -1478,7 +1478,6 @@ int main(int ac, char *av[])
 
 	conf_parse(name);
 	fixup_rootmenu(&rootmenu);
-	conf_read(NULL);
 
 	/* Load the interface and connect signals */
 	init_main_window(glade_file);
@@ -1486,6 +1485,8 @@ int main(int ac, char *av[])
 	init_left_tree();
 	init_right_tree();
 
+	conf_read(NULL);
+
 	switch (view_mode) {
 	case SINGLE_VIEW:
 		display_tree_part();
-- 
2.43.0



