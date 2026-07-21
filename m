Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931253D16E6;
	Tue, 21 Jul 2026 17:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654647; cv=none; b=qwg4cexNQwq+pfIscsxtCAJzv4lz4CEBYnuuHo1GfAs88iBG/sIKhplDEm/doS5SOwSFm4jDeCbZ5gPdAfEWXfMFwzTsX53VmkC6F/p/ajnmp2v1bFkhiJwjWa4u0mqkO8CRrvWqg+DoX1CaIBOJZzpUDKTyaTS2TuTu8yjhuMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654647; c=relaxed/simple;
	bh=nnkDMg5dEDT9t6I53htvHRu4by8eNAK7HxmFfy3rtjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bcJS+Qzqktow4nNJyWgMeZOXlY1N6HhQVlXZnhVMstG488qV8GkDoTdmxKByvkwtCzmmPOpS5Gx58q0Yy4smasaUNZCkRlN49dq7sm+XnCtNpALZW7g7aLCKtp/FisSka7dBXrW8Gk4dJ9o0ucO+omGFETU0pvb9F5YPjQHwkE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpN6C628; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpN6C628"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054921F000E9;
	Tue, 21 Jul 2026 17:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654646;
	bh=sdH66axjGpfQVsOlFpRb3H/90cI3sR3vVcy6FJUxleI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cpN6C628b7YZR93bby0yoOJ2OKW18i9lYpyka7rrNNGsptVBEeY4lGhzMgrJ2y5Sz
	 QtK2m8Um/m1e2i1P+IyX8JEhfd0F/InYlQyXG1iLqD4jMFV4s5qheIPkkeDI5ZHe8Y
	 XDj/7FmW5Dtlnjqi+f3zM2EfK6y65pemc8K7t4Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Lai <yi1.lai@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.1 1783/2077] platform/x86: ISST: Restore SST-PP control to all domains
Date: Tue, 21 Jul 2026 17:24:16 +0200
Message-ID: <20260721152634.803861312@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@intel.com>

commit 2565a28cdcdcb035e151d285efcba26bccb3726e upstream.

The SST-PP control offset is only restored to power domain 0 after
resume. During suspend, control values are read and stored for all
power domains.

Use pd_info->sst_base instead of power_domain_info->sst_base, which
only points to power domain 0 base address.

Fixes: dc7901b5a156 ("platform/x86: ISST: Store and restore all domains data")
Reported-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260528204521.3531456-1-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -1804,7 +1804,7 @@ process_pp_resume:
 		if (!(pd_info->sst_header.cap_mask & SST_PP_CAP_PP_ENABLE))
 			continue;
 
-		writeq(pd_info->saved_pp_control, power_domain_info->sst_base +
+		writeq(pd_info->saved_pp_control, pd_info->sst_base +
 		       pd_info->sst_header.pp_offset + SST_PP_CONTROL_OFFSET);
 	}
 }


