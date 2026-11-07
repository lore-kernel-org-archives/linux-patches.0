Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060996;
	b=VF9aKNEmKaVMKSZAPejebrvVxqXHCN9/ok3JqZe+JyCC0DYTnB1BeNx3I0I9uC3dUdu8
	 5jlV/y0J1PmkNT8DHJcs1BKUggey785WO92sM6Z/p/wrL9Le3eRNBLhqtwfEOLaAEZ6fx
	 CqggMNsD+wRipvivQ/Ky6q4A4gVv8B04C8foaSDryJ8nxZhX3xquX0bcjBoo2v0aXOWLe
	 ohvmrzR0l5oOLO5S+5eB/nh6d+dR/G4q12iG9QFdI7oRLDfpEEBvj67/lJpo6SlAb5npA
	 aCG6QcmGmTGLiBuIDvZvoQPaBVEXfdG2zgQK6JB1rW2f7Cs0Wkt4S5bmoJvAw0yhlRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060996;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h+mZwh2vhjokBpoHfQBQPvdEQwZinxy0RxtzsnU7i6Y=;
	b=I1NJ0i6iThGGJF27FX//iEOfBSmxg8PrSttsljcdWV39sre7O/e+nVCqRAnrJ5xaJgft
	 vW3wIiRespx/2zgl2y+72lFTWrjybfHT75x5amK/58j0R2SLwDdo/wQeasZ9cbQbaAC/E
	 iJM032jUpjAwX6Bwcp9D3X4vXlRyNwmGGs4SvEHgH60IfG3kfyLngFsFV29taeFnD+2jd
	 f8hCTBxnhC4f7lY//0WgrMKuwl1MmYfCnih70FGOk8HJ4qoUI1kW4dGKgpZaIAGAeojbm
	 kyeGlUb9cZJeZYSIzUXdsVevUan0Hln2Cf58zOIFBUlXK5uD+c6GMarLYf/8NNZMw6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cS9XSend;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFFD606D826;
	Sat,  7 Nov 2026 14:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cS9XSend
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1873A1F008A2;
	Sat,  7 Nov 2026 14:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060989;
	bh=h+mZwh2vhjokBpoHfQBQPvdEQwZinxy0RxtzsnU7i6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cS9XSend2/9UU8mqtHf1KqMl+Mgb1zabj1zUlyRsAlsB9vqA4AitfGEa6xC7nztLl
	 kCQB9mPNRq5lqOR6m60MLT21wxzGxMzVVP8RimTNXMU7WOL9UfEu+h80KA+ejsH6fE
	 FUYDg6TSsSrvHB54nSzbz5gbFcMRoQ/FRvrVZZG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0338/1536] ksmbd: preserve access denied status for copychunk
Date: Sat,  7 Nov 2026 08:39:14 -0500
Message-ID: <20261107135007.181361763@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit f7c0366e0a80bf8cd5eacc5479927abb50958b5e ]

The copychunk error mapping handles -EACCES in an independent if
statement. The following error chain therefore reaches its final else
clause and overwrites STATUS_ACCESS_DENIED with
STATUS_UNEXPECTED_IO_ERROR.

Join the -EACCES check to the remaining error chain so an access failure
is returned as STATUS_ACCESS_DENIED.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f81b65527dddd..2f0a58f1afc9a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8026,7 +8026,7 @@ static int fsctl_copychunk(struct ksmbd_work *work,
 	if (ret < 0) {
 		if (ret == -EACCES)
 			rsp->hdr.Status = STATUS_ACCESS_DENIED;
-		if (ret == -EAGAIN)
+		else if (ret == -EAGAIN)
 			rsp->hdr.Status = STATUS_FILE_LOCK_CONFLICT;
 		else if (ret == -EBADF)
 			rsp->hdr.Status = STATUS_INVALID_HANDLE;
-- 
2.53.0



