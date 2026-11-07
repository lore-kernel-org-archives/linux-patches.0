Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065569;
	b=zZGBF0JxjQlGUFE0WVQ7MwHDq0dSdTgWA6J9naIhc4cpFMSKikQcQrIIQ7z/iPJrH03Z
	 ZijUIhKbzHE7a1B9xY8f2NZYgk3YvIhuxEz/72b3O+ZMzx3fuIzHImUMWy9QtqzJ8IxPc
	 bFe408BjCqm0YEH7lzbrSVqsGvenNjtPdkYRiwstoY4F1F/tkl7bvu5qBFTgXerKTVUXK
	 lAY8Zxl42xqRnfE5pIVR4Wi6T8Lm8qkN/XgC5lfmjI2JwA+kXGc9th+Bo0mYRjUAElO7L
	 ZOC4J6bcRgvqBNLvvgRvCmEaEg0d6Z/HAoI0ynixbNsAm3ytLQWeBrfvAMC5xAbExdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8eaW1BzovXnPNWXcuZ7JWstWa0aJy4JNH2NE6qthOtw=;
	b=XN18bIonCwN4T2lqo6VEaomKsOqne7GbY+9lCdwAY6TkgSfrtHVx4fG9ObSFuHfTvufh
	 yxL9b/+DQl+IpkUoTGZGZ4nIKnEt8u2OmWMuI8VjROAX6fjUqhxbj5fHe7XjYVkSr08Yt
	 3ppXz6fwpYPju6royeojhX6/lUd8fkNGZ+Ao+MqbmhqgFJbkbqBPllUwLmOGGrFQvtKnk
	 bPJ/j+ztPCbEVbzNxY1xXscEvYvsJARKTVmrrbEPNgVQUdDbtulzNdtPddZvH3ThGBNXy
	 Xc6zABywyQDoX6KKwDD+fF+lZnFZNPoh7kJwv4XgZ3gSrchItn9S3v+ToHN8fS4c9Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T55VHlLd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4425606A335;
	Sat,  7 Nov 2026 15:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T55VHlLd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F051F0089F;
	Sat,  7 Nov 2026 15:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065568;
	bh=8eaW1BzovXnPNWXcuZ7JWstWa0aJy4JNH2NE6qthOtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T55VHlLdYZkAVEp7boHYh2GS1gz8/XroDLs/iHiI7k95hV9oEUau2BpQl3OD7w3Rf
	 Uh7VKQ/DgJSByLgjL2Otf6gQa+/0HcegfOIYnnv/50lHWV0Sw+OPmXdvKcaz+j2op7
	 QnPfDtAnxswZgxc1Bgx8k0ECT1WM5u6xi9NusiSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1206/1257] nvmet-auth: fix error handling on CHALLENGE failure
Date: Sat,  7 Nov 2026 08:58:22 -0500
Message-ID: <20261107135012.654856358@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shao Mingyin <shao.mingyin@zte.com.cn>

[ Upstream commit 96da408bb4a24bf87b366b13f41c2687d3c05671 ]

In nvmet_execute_auth_receive(), when nvmet_auth_challenge() fails (for
example when the initiator-supplied allocation length is shorter than the
DH-HMAC-CHAP challenge response, or the challenge nonce allocation fails),
the error path sets status = NVME_SC_INTERNAL and breaks out of the
switch. The unconditional

    status = nvmet_copy_to_sgl(req, 0, d, al);

after the switch then overwrites the error status (nvmet_copy_to_sgl()
returns 0 on success), so the AUTH_RECEIVE command incorrectly completes
with SUCCESS and the initiator proceeds with a truncated/empty challenge.

Fix this by freeing the buffer and jumping to the common done: label on
CHALLENGE failure, skipping the copy_to_sgl() entirely and preserving the
NVME_SC_INTERNAL status.

Fixes: db1312dd9548 ("nvmet: implement basic In-Band Authentication")
Cc: stable@vger.kernel.org
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fabrics-cmd-auth.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index f30c2539a6fd9..51d6ad4d021d0 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -599,10 +599,11 @@ void nvmet_execute_auth_receive(struct nvmet_req *req)
 	switch (req->sq->dhchap_step) {
 	case NVME_AUTH_DHCHAP_MESSAGE_CHALLENGE:
 		if (nvmet_auth_challenge(req, d, al) < 0) {
-			pr_warn("ctrl %d qid %d: challenge error (%d)\n",
-				ctrl->cntlid, req->sq->qid, status);
+			pr_warn("ctrl %d qid %d: challenge error\n",
+				ctrl->cntlid, req->sq->qid);
 			status = NVME_SC_INTERNAL;
-			break;
+			kfree(d);
+			goto done;
 		}
 		req->sq->dhchap_step = NVME_AUTH_DHCHAP_MESSAGE_REPLY;
 		break;
-- 
2.53.0



