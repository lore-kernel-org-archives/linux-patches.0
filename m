Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9DF23D7E5;
	Tue, 12 Aug 2025 17:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020965; cv=none; b=foZDDWk+K4CfTU7B6RYdykwQT4/4gbeCmGsYg2EC3Ff1Ej7INdlTl/si0WMat8eqFwvIBTiLE7bcx4o3pvgmhNpQ8mnE5TfBZFJ0Dhhgnh+wIuEqtFcyjfD7e9HIxwuYcsT0KawHIy5O5NrDbb+9JcCL9J8GERBPB1qFAdaOo6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020965; c=relaxed/simple;
	bh=eR3Wo1KeXAxO3l007SfkuQL73mkDXittDUAnmZasOH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qP7JN+OMRXaPfE0VONBobZm7LFMjOc2qLKYBjZ1kwy2yd4BbLiO2E+fq0SR+Lhbr/RopLfiS0jW/d1zQRuwctkISdUON5nbMLxPE1ujHeFmnpcNcvBfaidMSyWG6IBLzJMHXksHTXNa6FPUHvSDQfCkz90WD6qV5gT+jgyA0e8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TdmdZ0Se; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TdmdZ0Se"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB13C4CEF1;
	Tue, 12 Aug 2025 17:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020965;
	bh=eR3Wo1KeXAxO3l007SfkuQL73mkDXittDUAnmZasOH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TdmdZ0Sex2FPbr3s/EhY5/Sa1x2yqWKySRB2olTrq2DmSxshIBQ0t9PNJ1zUvMtLz
	 uqnNCr/Q6K/yokELNerwTkQrNNhLxZe70TCgk0aA/3rcT4zlmzA8r0tnLGinlXKILX
	 e8NOO6QW+KRvPPDjdlTKpiK4HGKzOEuE1GgQbZuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 193/253] f2fs: doc: fix wrong quota mount option description
Date: Tue, 12 Aug 2025 19:29:41 +0200
Message-ID: <20250812172957.012538506@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 17df9a02ccff..0625d5bce596 100644
--- a/Documentation/filesystems/f2fs.rst
+++ b/Documentation/filesystems/f2fs.rst
@@ -230,9 +230,9 @@ usrjquota=<file>	 Appoint specified file and type during mount, so that quota
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
 alloc_mode=%s		 Adjust block allocation policy, which supports "reuse"
-- 
2.39.5



