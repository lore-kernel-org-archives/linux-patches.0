Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7C61591E3;
	Tue, 18 Jun 2024 13:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716567; cv=none; b=eJxAMpaQufMH2/kINoPCVnFmJ2n5EL1DT8AG7NqQCzhgaSCe3BMDj6stpQ19+OcjHu36HD2U5tYzOK0TvhcqKuVIj96oTF0/cA0olGzhZeP2UtF/E29IACoLLzZTRgzZRVeZSSR4ee4oV/Slqtl42NX/U3mDkJWr5EP6j8dygyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716567; c=relaxed/simple;
	bh=DnPcxZrpOc390m7Wc2hgoV2xrx2XOC+k/6Aq82ShH7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgG9e6028/iZ+TmxIpmVTe91q6utoHfgLkdUDx3TfuXXN06XarNgGni5WQwx6VLs31P3V7KLOuMl3QWeEAiM3+pQ4Se6W4MCj5/ZSEGhxKNvcLtjbFKEfnlY/hhD2DkmAyTPuT/JugnW7WL8gdENWPPdJHM35nIBHbedA8+GhBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pejK7s5y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pejK7s5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69788C4AF1D;
	Tue, 18 Jun 2024 13:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716566;
	bh=DnPcxZrpOc390m7Wc2hgoV2xrx2XOC+k/6Aq82ShH7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pejK7s5y1zSwEvTvBCZqkVlrka29Dqy4YlgauhcNkrk/NHkZJdrfGH2I+lZt5PX/V
	 OUZtjQHVsRObTssmMbAFbbIR+0WXGzLohM8z7yHd/nMQacve1zvFHonT3txd7Dh79m
	 5sAxZcqHzWTPjMFOEsh+8uC461qiXKrK85iSYUCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 656/770] NFSD: Remove unused nfsd4_compoundargs::cachetype field
Date: Tue, 18 Jun 2024 14:38:29 +0200
Message-ID: <20240618123432.609659312@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 77e378cf2a595d8e39cddf28a31efe6afd9394a0 ]

This field was added by commit 1091006c5eb1 ("nfsd: turn on reply
cache for NFSv4") but was never put to use.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/xdr4.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index 1e83fda7601ab..624a19ec3ad11 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -724,7 +724,6 @@ struct nfsd4_compoundargs {
 	u32				opcnt;
 	struct nfsd4_op			*ops;
 	struct nfsd4_op			iops[8];
-	int				cachetype;
 };
 
 struct nfsd4_compoundres {
-- 
2.43.0



