Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5FC306D3F;
	Tue, 26 Aug 2025 14:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217471; cv=none; b=EbhUaRi/UmV8WhMjNRDTooXDJFoWeYqGd0T4ZRD2VTPrEahI+J4PQqzvKjAJqMyZlsV/OMWREJ4+aIr+LVQO8zZXduB93D0NTjkNWhjh5avAyxnk+fEc+WPcRDf0JxqMKbx95r+IgvUX4ZH7xIfdTDzziP36CgvTqGimeaH+4M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217471; c=relaxed/simple;
	bh=59pRy7NAx5xHwFddHvc9g/Rdq8MDaQ1HmCfbHATA21I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CG8Q4yBLU0EVhsMy/WLUJyribs5cfIMtrRMeljB+Nkq34J6fmXBcm8VIhM8Omsnn+mYEHjI4wY1kir45n1v6gKY6lQiNQJlBqr0p0DaFrVq7K1C4KossxERYR2rPNje4vmwPHV1mJ++i1wymOIlVLWI0WTcq2IKU3THcgWJD58k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KT+AQTjn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KT+AQTjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33168C113D0;
	Tue, 26 Aug 2025 14:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217471;
	bh=59pRy7NAx5xHwFddHvc9g/Rdq8MDaQ1HmCfbHATA21I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KT+AQTjn8UgYEkSx3WUqFNY3XsYmvoGl/jNH3JLG5WnPrjx0VHRc4bRLJKcoZxbEi
	 eRtfRXd9DpgPsFtrxmwOtkGEJvjI8JfgnC98rkCeI1qnEv0lAz5qmkPlrWN54aL49Z
	 KGhF5Frw2hDddIsgzg+pXiO/luZWGq73pKw2X2fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 155/523] f2fs: doc: fix wrong quota mount option description
Date: Tue, 26 Aug 2025 13:06:05 +0200
Message-ID: <20250826110928.300767249@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 81b6ecca2f15922e8d653dc037df5871e754be6e ]

We should use "{usr,grp,prj}jquota=" to disable journaled quota,
rather than using off{usr,grp,prj}jquota.

Fixes: 4b2414d04e99 ("f2fs: support journalled quota")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/f2fs.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/f2fs.rst b/Documentation/filesystems/f2fs.rst
index de2bacc418fe..483573166ac9 100644
--- a/Documentation/filesystems/f2fs.rst
+++ b/Documentation/filesystems/f2fs.rst
@@ -203,9 +203,9 @@ usrjquota=<file>	 Appoint specified file and type during mount, so that quota
 grpjquota=<file>	 information can be properly updated during recovery flow,
 prjjquota=<file>	 <quota file>: must be in root directory;
 jqfmt=<quota type>	 <quota type>: [vfsold,vfsv0,vfsv1].
-offusrjquota		 Turn off user journalled quota.
-offgrpjquota		 Turn off group journalled quota.
-offprjjquota		 Turn off project journalled quota.
+usrjquota=		 Turn off user journalled quota.
+grpjquota=		 Turn off group journalled quota.
+prjjquota=		 Turn off project journalled quota.
 quota			 Enable plain user disk quota accounting.
 noquota			 Disable all plain disk quota option.
 whint_mode=%s		 Control which write hints are passed down to block
-- 
2.39.5



