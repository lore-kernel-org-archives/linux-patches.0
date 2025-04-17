Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE292638A1;
	Thu, 17 Apr 2025 18:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914797; cv=none; b=uPCF1F3FIFS57wh+t7MiWaXwcCToGpvMTmdznCZw3l7mL3XqOro+ggT2fCSXHKu5k1zL4dZRVCLpHOESnv1+EgQrxJhaKn2keohTxVt2CsMW7z3hd7W/wcGQx9YxjVBAq4MqIWQGnW/pkLfCeh6N7ghaNiGkZCjfT7y2nU8KDkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914797; c=relaxed/simple;
	bh=51FfL0q6TVRbBU9VcGEMoeR8/mbivhAoueQVE8Guhr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uoppBIsRsduJqv4roeFRIyXA2qz2iS+vaC3irH+NJTeCQo8bpBkEK6PlFx+qqiRRw6BvJOb+CfuaqMq+Ov2eh+aqPz+6zRbYYFHdaJP4U9EWtyuMLmCeywwZOZxTMh5R8YTI7pBI9BMsucNtULmWsAz9yOH/RQ5Z0AtdtSOGHAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jhcU8FUH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jhcU8FUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63989C4CEE4;
	Thu, 17 Apr 2025 18:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914796;
	bh=51FfL0q6TVRbBU9VcGEMoeR8/mbivhAoueQVE8Guhr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jhcU8FUHUVPtnVwYNc12S3iH/44BD0AepA8ybyR9DTn8+1DWUw8h6gks5uKGRwwjI
	 XlJk5Ju11r3XpiBVcflOGXyreEaChD7zjzAz6gRHGpvzDSdpSLhZPDhGAv+0QcMgRt
	 BkpMHAitQ4ejRhaHemxsEXlWKidkazfqNzcExcCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Herbert <Marc.Herbert@linux.intel.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.13 333/414] mm/hugetlb: move hugetlb_sysctl_init() to the __init section
Date: Thu, 17 Apr 2025 19:51:31 +0200
Message-ID: <20250417175124.826801322@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Herbert <Marc.Herbert@linux.intel.com>

commit 1ca77ff1837249701053a7fcbdedabc41f4ae67c upstream.

hugetlb_sysctl_init() is only invoked once by an __init function and is
merely a wrapper around another __init function so there is not reason to
keep it.

Fixes the following warning when toning down some GCC inline options:

 WARNING: modpost: vmlinux: section mismatch in reference:
   hugetlb_sysctl_init+0x1b (section: .text) ->
     __register_sysctl_init (section: .init.text)

Link: https://lkml.kernel.org/r/20250319060041.2737320-1-marc.herbert@linux.intel.com
Signed-off-by: Marc Herbert <Marc.Herbert@linux.intel.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4870,7 +4870,7 @@ static struct ctl_table hugetlb_table[]
 	},
 };
 
-static void hugetlb_sysctl_init(void)
+static void __init hugetlb_sysctl_init(void)
 {
 	register_sysctl_init("vm", hugetlb_table);
 }


