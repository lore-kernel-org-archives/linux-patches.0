Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060997;
	b=CD5sWEL0KY4vrTGwlVn8JOVREywL4nx2W1Pjaa8nfSjHwIfwRGQeP/WWcsbcwA4DTZ1H
	 xpYAm2vYRtLx4dS3yET7KAXm7GUTQ2h7i5JplrCHvkEHIZEd/GxVBXUZozEP2YSn5G6ab
	 EOB7sxcQxS/Oq87OdBZ0ZXrpPhdBVJ+/5LEusIgqm/yIuTVcBug18RQSovGL8JK+NN6lP
	 rg3yUPfThg3AcS1hBatResumJG1FPzDJKTl6oAesmdADfTYPVp8QXvTSLhh7H595NgUQj
	 cD2rY1uBc2KZdbdq35DMU8RdRQzM+9iAROrDf4WXIIElT0uX+q2LHvtSTc7ItOaXu4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7O715XPXQkh20IKrfBSHlYIIkAQhyUbHcy1nJaWdhW8=;
	b=vszYMrcb9ZwbVaSJfoPT8wYmUjf9m2KzUT46pVVeKgbc++otCQn1Ok0/sOwzR9qoEyT6
	 FYDd2t1pczH2BXCrb/6+etn8S5tZA22JMYb1uJ47trJDOcGX8CqGEDODKnBPpcLE5lyuu
	 T7jdj+NBX7tFUTsIjCC1D2ytvFXMOFg5bNfvYG6mJ0JeM9U24tYQyyo8X7QMjBvSUaSFB
	 53TmfCCo5bI/sHCjhTNmevvrX8nL1WzJvEegHAMds2sIsC9aSWZq7xXkShiCUdP9QKibX
	 /N1p/qAg9aaLCwXZx0m+QOoxKd7/75/RPDAPakbXnVXgauYVNu8SipEJMlUy+SAl4Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CZCGO6Wl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2588606EE8F;
	Sat,  7 Nov 2026 14:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CZCGO6Wl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B9F1F008A5;
	Sat,  7 Nov 2026 14:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060991;
	bh=7O715XPXQkh20IKrfBSHlYIIkAQhyUbHcy1nJaWdhW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CZCGO6WlsMjQY6ArHQALm+ULCAp1XC/cqcb0lYLqlHWJQee/f+TLnKX9Ck6uBEtdB
	 qHWHgntnMzPutYtlGKdY7nuhf4bXIUO6wT/SWlI4IrUgqMt61ZfrcFxADxOC+xRO0T
	 oTK4SO8DMdRo8vVvG4Ye47tchzdjffXERTV8jxvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0340/1536] ksmbd: fix durable handle v2 default timeout units (60 -> 60000)
Date: Sat,  7 Nov 2026 08:39:16 -0500
Message-ID: <20261107135007.235297418@linuxfoundation.org>
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

From: Gael Blivet <gael.blivet@gmail.com>

[ Upstream commit c1d7bbfc5e081875053723d1a69eb2cf341eaaf1 ]

When a client's Durable Handle Request V2 sets Timeout=0 ("let the
server choose"), fp->durable_timeout was set to 60. Every other use
of this field is in milliseconds: DURABLE_HANDLE_MAX_TIMEOUT (300000)
in smb2pdu.h, the nonzero branch immediately above
(min_t(unsigned int, dh_info.timeout, DURABLE_HANDLE_MAX_TIMEOUT),
where dh_info.timeout is the wire value and already milliseconds per
spec), and the scavenger in vfs_cache.c, which adds it directly to
jiffies_to_msecs(jiffies).

60 is off by 1000x: the handle becomes scavenger-eligible 60
milliseconds after close instead of 60 seconds. A client requesting
Timeout=0 is relying entirely on the server's default to cover the
gap between a dropped connection and its reconnect -- 60ms is not
enough time for even a fast network blip to be detected and
reconnected, so any real disruption loses the race and a subsequent
DH2C reconnect fails with a durable-handle lookup miss instead of
succeeding.

Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2f0a58f1afc9a..89eea430e9155 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3681,10 +3681,17 @@ int smb2_open(struct ksmbd_work *work)
 					min_t(unsigned int, dh_info.timeout,
 					      DURABLE_HANDLE_MAX_TIMEOUT);
 			else
-				fp->durable_timeout = 60;
+				fp->durable_timeout = 60000;
 		}
 	}
 
+	/*
+	 * conn->is_aapl detection above (this function's create-context
+	 * parsing) is skipped on the reconnect path below, since a
+	 * reconnect always arrives on a fresh connection -- if the client
+	 * cares, it sends its own AAPL context on this same CREATE, which
+	 * this function's normal (non-reconnect) parsing already handles.
+	 */
 reconnected_fp:
 	rsp->StructureSize = cpu_to_le16(89);
 	opinfo = opinfo_get(fp);
-- 
2.53.0



