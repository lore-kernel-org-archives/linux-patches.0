Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C583917E8FB;
	Wed,  3 Jul 2024 11:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006184; cv=none; b=oLbrS9e9nzYAFEcrD/vtQUSMmd/wqH3vTfDJ02Ze1TU8GwBOXkq/nPeErz39EMkTb8s6whOrLO0c6bTR9WCU+Khn9ErVQcZmAFVZL8BHWl4UaxjEb0lZOEAj798NV1PL7Vg6M5nHKcv340uRdqj09cGJELNQ70Ejy+SpKzvSYU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006184; c=relaxed/simple;
	bh=80Zd6TitCCfhjshJMPIhViA1yD7rGtpgjfWZZfKV6DA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfsHyQg8pPKzf7sGa2g2N57t3YRc/DQHj2qdHBh3LGXSXoIks4C4fyJmlFmvrYc1NwuZEdRaolkcNoCLXW7ZIIZZ84wqUPkiH8478BkpPXvVaFWJMSe4JbfayUdT/qjVrypfbdyGqUnPeVpHya2GEbXde6dqDvBYy2/TeuS6QDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bds9FXgj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bds9FXgj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD76C2BD10;
	Wed,  3 Jul 2024 11:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006184;
	bh=80Zd6TitCCfhjshJMPIhViA1yD7rGtpgjfWZZfKV6DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bds9FXgjyJrHj1luSkXEEUbs6Ae2tu7Hu/rirwM/C0BAI6JVvLT83mID1ADWeix7u
	 XWoliinOC4dOyqrTR0DNDPbR0ydVvwTfH5vuojSBD3VW+FB5+XXhsRK6f1rtMM8LrB
	 3F69/x6+knfaN74x+n19NNyeF7ABwHxU+KJd/Xvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.15 329/356] kbuild: Install dtb files as 0644 in Makefile.dtbinst
Date: Wed,  3 Jul 2024 12:41:05 +0200
Message-ID: <20240703102925.559522049@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragan Simic <dsimic@manjaro.org>

commit 9cc5f3bf63aa98bd7cc7ce8a8599077fde13283e upstream.

The compiled dtb files aren't executable, so install them with 0644 as their
permission mode, instead of defaulting to 0755 for the permission mode and
installing them with the executable bits set.

Some Linux distributions, including Debian, [1][2][3] already include fixes
in their kernel package build recipes to change the dtb file permissions to
0644 in their kernel packages.  These changes, when additionally propagated
into the long-term kernel versions, will allow such distributions to remove
their downstream fixes.

[1] https://salsa.debian.org/kernel-team/linux/-/merge_requests/642
[2] https://salsa.debian.org/kernel-team/linux/-/merge_requests/749
[3] https://salsa.debian.org/kernel-team/linux/-/blob/debian/6.8.12-1/debian/rules.real#L193

Cc: Diederik de Haas <didi.debian@cknow.org>
Cc: <stable@vger.kernel.org>
Fixes: aefd80307a05 ("kbuild: refactor Makefile.dtbinst more")
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile.dtbinst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/Makefile.dtbinst
+++ b/scripts/Makefile.dtbinst
@@ -24,7 +24,7 @@ __dtbs_install: $(dtbs) $(subdirs)
 	@:
 
 quiet_cmd_dtb_install = INSTALL $@
-      cmd_dtb_install = install -D $< $@
+      cmd_dtb_install = install -D -m 0644 $< $@
 
 $(dst)/%.dtb: $(obj)/%.dtb
 	$(call cmd,dtb_install)


