Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82F213C3E0;
	Tue, 18 Jun 2024 13:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715855; cv=none; b=gALVOX2Sh4uGHkTCdJZQiqhV8AlpJHlpgrKb8GyiEPxQdftp5onDvfAyFSRpZIoy+6fuzjNxXBFuhKB3a+30dCNzHF4Vn+/+xKT1jw6njpscJi+G2y+u+u6hFoxxy7zo5UE1bDFkzPyi5FUS+tyuZip+yovpFr0zEey29y+S9cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715855; c=relaxed/simple;
	bh=oOrwIzpNgO9T1ctoUng6i9HRp7EJGg9bIByoAM0Qjjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5OX3VL+enGVDJvYDOIhG1Bbg5UbiOkdkO8nFPqrlZ8ERiRe3z7Qqrcq9iEn8ynVyg6bCtgugdTQKkiIorFm1P+gV8KqsZxqGEoaBaKLzgMigiCzxEe3zx1LQiedzB794yvEjGujceUX7rFONm4TsdkOaUlkhNRIopZZmYsTf0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fhhaEYBm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fhhaEYBm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2313DC3277B;
	Tue, 18 Jun 2024 13:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715855;
	bh=oOrwIzpNgO9T1ctoUng6i9HRp7EJGg9bIByoAM0Qjjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fhhaEYBm3Hf1tfdL890eMdnR8OMZxBNcTdDW9XoTa4dV06U6deVhT9xwdJPF2wfHy
	 F5oONTy6fp4+P0ZU7NJ7oYjtgfP4HVrpDnREzT5IKymRBR1gI/Gx+SiuJObO9m+ieC
	 FhAKpchUpnx+QJkeIs4VLtmHLj2zZpHhf2EMU7ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 418/770] NFSD: Fix sparse warning
Date: Tue, 18 Jun 2024 14:34:31 +0200
Message-ID: <20240618123423.420076514@linuxfoundation.org>
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

[ Upstream commit c2f1c4bd20621175c581f298b4943df0cffbd841 ]

/home/cel/src/linux/linux/fs/nfsd/nfs4proc.c:1539:24: warning: incorrect type in assignment (different base types)
/home/cel/src/linux/linux/fs/nfsd/nfs4proc.c:1539:24:    expected restricted __be32 [usertype] status
/home/cel/src/linux/linux/fs/nfsd/nfs4proc.c:1539:24:    got int

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 52f3f35533791..eaf2f95d059ca 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1508,7 +1508,7 @@ static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy)
 	u64 bytes_total = copy->cp_count;
 	u64 src_pos = copy->cp_src_pos;
 	u64 dst_pos = copy->cp_dst_pos;
-	__be32 status;
+	int status;
 
 	/* See RFC 7862 p.67: */
 	if (bytes_total == 0)
-- 
2.43.0



