Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961CE1BE22F;
	Tue,  2 Jul 2024 17:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940504; cv=none; b=YYxIL9EGoM/7xgdSYHp1qMN6MCSBaQ1UwP6+65RbPiT8mhY51AzK/7HzBWxCzuw4sSq/M1xmNY5Oq1wHN+zfjbV1ResKsXdlC/kTNWyLqJ2T+xs1IaIUQsgP6t46UpAdaXZ63RWK2ZhAUS7I52mJOTwb2FfbBdjL50GRvA8dAWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940504; c=relaxed/simple;
	bh=vaUmNJOy/RcA2KrPfBX+G73YKSsbe49oWbjYVYKkga0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAfF9//4NI3ER/BEOD5G+tfK6DfAYjGcD9TrBZ/y1NJieC2e8K6wGWBdn3h3FqJiVU7XiLePlBO5nzt4B8+O9shyYcyfYxRRy0XF9KWOSH049uQAV7PrRh3F+1i1FT5iM2CWRNuLxFe0dxBdI0RsbbLjs1wAEUiVry9Tih6bUiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uXgj5scq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uXgj5scq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F835C4AF0A;
	Tue,  2 Jul 2024 17:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940504;
	bh=vaUmNJOy/RcA2KrPfBX+G73YKSsbe49oWbjYVYKkga0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uXgj5scqnYoopRdtJOXoGMydnzFCZNfEg0OX5ikwgBOxPtet9pwg6dt6CX03fyc3l
	 3lZatELpusaKj01LlrgFWmkcsf9D9fycDj+wqiqRJP/gyeHc4KOTyfIgI9Bmu0+MHD
	 ll5mYgL+QRFFMhMzyB7lLBTu7oPAV60RsWlKLj1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.9 174/222] kbuild: Install dtb files as 0644 in Makefile.dtbinst
Date: Tue,  2 Jul 2024 19:03:32 +0200
Message-ID: <20240702170250.627869282@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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
@@ -17,7 +17,7 @@ include $(srctree)/scripts/Kbuild.includ
 dst := $(INSTALL_DTBS_PATH)
 
 quiet_cmd_dtb_install = INSTALL $@
-      cmd_dtb_install = install -D $< $@
+      cmd_dtb_install = install -D -m 0644 $< $@
 
 $(dst)/%: $(obj)/%
 	$(call cmd,dtb_install)


