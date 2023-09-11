Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238F514AB2
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DDFC433C9;
	Mon, 11 Sep 2023 15:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694446158;
	bh=NqgXe3JzTOZf3oco7kemUKIOGUy36und71TXzUHpda0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+rCxnihy6Z9a3IRjfn4Ba7pVj2PwctbGCAteLp9RGKOWMGYwfbi9SBIj3aW5btcb
	 JckQ75OBVTKgTHKuMRs0Rf83qD7QzT5IOZvkgTPLRViXdBUvPUexE4Upc74auCUBUM
	 5WD7DIy3PSQBNGubQcjPOxL15lhrN2fHyl91FMzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.1 576/600] s390/ipl: add missing secure/has_secure file to ipl type unknown
Date: Mon, 11 Sep 2023 15:50:09 +0200
Message-ID: <20230911134650.620392113@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Sven Schnelle <svens@linux.ibm.com>

commit ea5717cb13468323a7c3dd394748301802991f39 upstream.

OS installers are relying on /sys/firmware/ipl/has_secure to be
present on machines supporting secure boot. This file is present
for all IPL types, but not the unknown type, which prevents a secure
installation when an LPAR is booted in HMC via FTP(s), because
this is an unknown IPL type in linux. While at it, also add the secure
file.

Fixes: c9896acc7851 ("s390/ipl: Provide has_secure sysfs attribute")
Cc: stable@vger.kernel.org
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/ipl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -503,6 +503,8 @@ static struct attribute_group ipl_ccw_at
 
 static struct attribute *ipl_unknown_attrs[] = {
 	&sys_ipl_type_attr.attr,
+	&sys_ipl_secure_attr.attr,
+	&sys_ipl_has_secure_attr.attr,
 	NULL,
 };
 


