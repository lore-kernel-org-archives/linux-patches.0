Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051591;
	b=BpyJXChCBklXCMFCcV07bi4l02tll3Gaq45rIRrG279NSTMh1z5hi3rOC8JIGEoiOyvD
	 tpvbmYrFl2yUyKnhelbSpEU5bMvtLXbD1V0khOeNHY8dVp+h3aoPldMI0GazC02FQ+RXH
	 bOiK7kGxzF5M/GEgdZayzRBR+cTKuN1w7sz8chaJyOjfqLfJNnSqXA6Sna5L64Xw1vK/u
	 M9vrNkDJT4GxwUX1Nygux73uBsnwGXURu7lqVVAJTkTtgSHy8WbaHHRZ7swzWY8iJmg3k
	 LXJs/nJTj4ZRGxuwY1+u8vcDCTMZ3Z1Ug0it86N2g8vJfNIbfTSBzecNQM1fXJ/dEhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xBscOiQKnwd0ZG1IA3z0zf0/1IvMktAgv5udXBrPY2U=;
	b=Cnebd0vAWDAxUspDtxDJZOhPNm9r96BYB7iV8luYlQVEstzpRalEzzhSbfuJeZa6NhEl
	 kf+7okTq9eBtjOmwYfc2RFPxn+g2s75Nnw3fMOl24RKXp12YL5x92cdVfyITZE+6oX0si
	 I/Ou4yikANoK1++biJ8Eig/PHGX16IdKtCbsMEh2X/caPNtcCwXa9iBkE1ZCK3ped4oFA
	 LSZcCG15+K257AuXrewkUkCikMpMUVUFCsbDVx9pTZ8WH55pvTM9Si8S9bAgHk3gsdbT/
	 Xu5T8k2vXw8/QiFhY76DqOlPW2nLWdnEjrw/py3wTgUpWS+/p46xuMsEDhue4VZuSrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vuQy64VI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C9F606A325;
	Thu, 19 Nov 2026 01:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vuQy64VI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CE61F000C4;
	Thu, 19 Nov 2026 01:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051591;
	bh=xBscOiQKnwd0ZG1IA3z0zf0/1IvMktAgv5udXBrPY2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vuQy64VIaN3lc9mu5nnjbl7xSOJqdi1VxV/Kw2isli6ljZ9569VvAa6rMXzM4geF6
	 bIzAusYHJDMiSspROnJkpdjP10pgmARe3IIc2g77MBSTZmIBuSWFr2IEwmMx4WqyMe
	 dTGO9jR3Sh1hrOjj7CvBnCgniZDSofTzh6+I1uU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0216/2214] ksmbd: honor client signing-required in all modes
Date: Wed, 18 Nov 2026 15:31:32 +0100
Message-ID: <20261118150018.815641506@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit bc2f3f3dd69424f76e2ed3dc53d29bfd6c9966d4 ]

The SMB2 NEGOTIATE request's SMB2_NEGOTIATE_SIGNING_REQUIRED bit requires
the server to set Connection.ShouldSign. KSMBD represents that state with
conn->sign, but previously set it only when its signing configuration was
auto or disabled.

Set conn->sign whenever the client requires signing, independently of the
server's signing mode. Keep the mandatory server-mode handling unchanged.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 430c1e075353f..e54a18b6d4eb5 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1257,11 +1257,9 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 	rsp->SecurityMode = SMB2_NEGOTIATE_SIGNING_ENABLED_LE;
 	conn->use_spnego = true;
 
-	if ((server_conf.signing == KSMBD_CONFIG_OPT_AUTO ||
-	     server_conf.signing == KSMBD_CONFIG_OPT_DISABLED) &&
-	    req->SecurityMode & SMB2_NEGOTIATE_SIGNING_REQUIRED_LE)
+	if (req->SecurityMode & SMB2_NEGOTIATE_SIGNING_REQUIRED_LE)
 		conn->sign = true;
-	else if (server_conf.signing == KSMBD_CONFIG_OPT_MANDATORY) {
+	if (server_conf.signing == KSMBD_CONFIG_OPT_MANDATORY) {
 		server_conf.enforced_signing = true;
 		rsp->SecurityMode |= SMB2_NEGOTIATE_SIGNING_REQUIRED_LE;
 		conn->sign = true;
-- 
2.53.0



