Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6A415CD6D;
	Tue, 18 Jun 2024 12:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714776; cv=none; b=iAEEqd9UVVjgT4IEw9m4yZXkRaWYoAu6LeLtGz//50cnEuCcguMt/M/9ngydQfr7CEL8bf4WJZ3QyMj/Svrfddj/jawxkqonBbSSh7xCZ2Xo0yJXK47rrFx6T8k+gywGJwmL8+UIcv4DsPQhUfHdDR+2aKiAGsrZeb1jH+zMc9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714776; c=relaxed/simple;
	bh=Iszeg3wk4pzRDVTCkAcy1ZS3Z/4GktyYDylCMaXIzA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqEyRO6uoB0u6XskY3vJJb/FUr0QNvCugdeweVmdYNkwVqHqc1TaTgZWgUjC3abxq8esohbsXU9NMyjJpn2GsxWfnKAarwpwRN6vQ/ofKgpau1sDMwlbs3FGZsvD4N0rYWoHf9ngXHUEuRizkHoE6ipcaftXFtMtk6ctpCzmhTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQlvxslg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQlvxslg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BA1C3277B;
	Tue, 18 Jun 2024 12:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714776;
	bh=Iszeg3wk4pzRDVTCkAcy1ZS3Z/4GktyYDylCMaXIzA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQlvxslgrly4mZDCsY+jN8YJN2ecX4yBLE1I9xijcvMc9uP2ysh85IP3MRFduuD82
	 KUcI2c1BOXpbgxe5R2kYjcUWWs5m2JPxJqzNEqnS5Zf+WiTPXCYx++DUmHuo7hui2X
	 dloKcDkhpWs1kK2dl/oYpDKGVAQFt6HUfyZh+9jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/770] NFSD: Replace READ* macros in nfsd4_decode_offload_status()
Date: Tue, 18 Jun 2024 14:28:58 +0200
Message-ID: <20240618123410.560346986@linuxfoundation.org>
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

[ Upstream commit 2846bb0525a73e00b3566fda535ea6a5879e2971 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 09aea361c1755..101beb315d963 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2048,7 +2048,7 @@ static __be32
 nfsd4_decode_offload_status(struct nfsd4_compoundargs *argp,
 			    struct nfsd4_offload_status *os)
 {
-	return nfsd4_decode_stateid(argp, &os->stateid);
+	return nfsd4_decode_stateid4(argp, &os->stateid);
 }
 
 static __be32
-- 
2.43.0



