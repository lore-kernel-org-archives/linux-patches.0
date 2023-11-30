Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA43495C2;
	Thu, 30 Nov 2023 16:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVGGQfAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2424C433C7;
	Thu, 30 Nov 2023 16:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361476;
	bh=pDbjEIGl7db5bwjEWb3KNvvAs1I5t/4YgkpAT3J2l3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVGGQfAQ616VUBAMDCvn+h2Z3LJV4NvsO1aSfYs2k2ZbF+73uNRvlrdi1tD7SvJ3s
	 BSTFcPsKhiL6F1CXJq8KLw4FsaAYMuBI3+dXSfJeMnCmwbhGgTD8wAd+7NZzqWPFvu
	 h+Ss2Is9uthIf3i5lEA0iFgF9Y00/UWk3nNuTc2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/112] s390/ipl: add missing IPL_TYPE_ECKD_DUMP case to ipl_init()
Date: Thu, 30 Nov 2023 16:21:25 +0000
Message-ID: <20231130162141.533767815@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Zaslonko <zaslonko@linux.ibm.com>

[ Upstream commit 673752a839694133a328610fcbc54f3d59ae87f3 ]

Add missing IPL_TYPE_ECKD_DUMP case to ipl_init() creating
ECKD ipl device attribute group similar to IPL_TYPE_ECKD case.
Commit e2d2a2968f2a ("s390/ipl: add eckd dump support") should
have had it from the beginning.

Fixes: e2d2a2968f2a ("s390/ipl: add eckd dump support")
Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/ipl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 05e51666db033..8d0b95c173129 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -666,6 +666,7 @@ static int __init ipl_init(void)
 						&ipl_ccw_attr_group_lpar);
 		break;
 	case IPL_TYPE_ECKD:
+	case IPL_TYPE_ECKD_DUMP:
 		rc = sysfs_create_group(&ipl_kset->kobj, &ipl_eckd_attr_group);
 		break;
 	case IPL_TYPE_FCP:
-- 
2.42.0



