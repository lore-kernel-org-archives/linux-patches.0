Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036181;
	b=msf7kcqKfuB8OSxLh5FZ9EOA4njy/szmL4qJWtOn/kWYyg/KckX1/DxpbPtGRsAH+cU4
	 azaqdcLXACiAXwG4U6m7zw7YDrm7rf0CxPAxUQrv+xkLV0IBUdn6W0fz0SuOVspx7PAwU
	 U4duvTGxzJnllLR8HMqrbHVMmHGDO5M3DguTrxgWIvMIPHyWM26GlXAYf+zz2mpQq5ZDc
	 SDWgYAp3pnJb6VPxBKc1IzIMVWHjUQOx+IQatNI48jFv8xgRAgDEBt05zdE/EQlNFkWG1
	 R+fEBY4LtC0QbghI4QiluENYijGmvSwebb7kDpCTAAN4aI61AMa7eYB9+3bNZyNWKjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036181;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K71NA9ZoDABRUEtaGzw53pBYEV4CQaKaN9hgsc21xGI=;
	b=QTP0uDKjfTDdlct3xpc9TjGKc4EvVygM99C75yD/9dazHNXuAuLYdQtG21j2o0iByj67
	 S5w4yRMI85J0G0PQBtwtGGv0mn6CR1h+lW6WdVogFz5/sFZyWEnJUUUkHsk5DGFzlfnx2
	 WltH/apFZPMF0VmLItxVuGxUigzYu53USkuc+ksw96YQ1lMtPuMA1jWZ3v58IoWs4HFYf
	 0dx8uy42GYS89EoQi9YlbKZ5EPb7+0mdqztXH8sElmjCYxDDDD4b4p0XCOjcs+YPY2io+
	 wQis2/jU1kvkH401mrvO0TLuv2sADigWwMTYjUBhDe8RHKrsOVu6fZzb+jVEau8PxKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A3aI9meB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADB6606A33D;
	Wed, 18 Nov 2026 21:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A3aI9meB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345381F000C5;
	Wed, 18 Nov 2026 21:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036181;
	bh=K71NA9ZoDABRUEtaGzw53pBYEV4CQaKaN9hgsc21xGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A3aI9meB4r8cxJyD56Wado9z74KaEiRCATlESTwdXF3qNPYxSXuNQVRVTUxUuxdrJ
	 AXA7uFNLDeiRGtn4/B2Rt1/LYBsDD1djJa7a+fGIMuHUqLY/qT9g16UD92IlCg4Mo5
	 i84YYCvaeKa0tuyFHnRv7h5EUy6i57yP2Zgu9qOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0966/3318] pseries/plpks: validate input to plpks_signed_update_var()
Date: Wed, 18 Nov 2026 15:26:28 +0100
Message-ID: <20261118150348.645495521@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srish Srinivasan <ssrish@linux.ibm.com>

[ Upstream commit b59ff2d50b817eeec1259f357aae821c7834007f ]

plpks_signed_update_var() dereferences the supplied PLPKS variable pointer
without validating it. A NULL argument could therefore result in a NULL
pointer dereference.

Reject a NULL pointer argument with -EINVAL.

Fixes: 899d9b8fee66 ("powerpc/pseries: Implement signed update for PLPKS objects")
Cc: stable@vger.kernel.org # 6.3
Signed-off-by: Srish Srinivasan <ssrish@linux.ibm.com>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260923182816.151451-4-ssrish@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/plpks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index 9a5e2871daef2..52a3638b35ff8 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -434,6 +434,9 @@ int plpks_signed_update_var(struct plpks_var *var, u64 flags)
 	u64 continuetoken = 0;
 	u64 timeout = 0;
 
+	if (!var)
+		return -EINVAL;
+
 	if (!var->data || var->datalen <= 0 || var->namelen > PLPKS_MAX_NAME_SIZE)
 		return -EINVAL;
 
-- 
2.53.0



