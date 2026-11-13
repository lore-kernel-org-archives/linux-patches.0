Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585985;
	b=V+/i73p6fmvm36YZ6OIx8cu0QLTZKiqCRRYtk0/E33z2Uz21tlONjrfZKettIAzN57+a
	 H0RuBlc3cK0lx++lqNP69CIREOYD7OBJCOfMB4isOSvOhSybFurPeEJbgDabQ5htDMfKR
	 o9l18Cp7Pz/9q4tNJ8k7Dz+GTySVvDoLeb3kBMwS0WITvHsN2OyqdN7psXvVW74Egm2NL
	 P9oyJBHXjL6ZFJmcDYl5xzhlBRLK79O18tdBPVPPg6kk1nK7yA2SXupk97xVlJOC/H0Dj
	 uRZYzSQpBTaw6ghlvWPiX8DZ0++SyWTeGpq+36fimNHVBwZqSjFjQJkfYVVkUxhAxCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xEtLKOs1x7+eqRbdKdULa0f6eoUmbEPdaUzd6fuCjIk=;
	b=BNzhw/TteVlQKV3A+pLdD5XxXsJULpE8YNiVzwmpy7l7jjNIz+scBNjpaULtFp12pl6s
	 lXDK2VXjMWWOieOc4q+WMI+vAohTY/ePfBVqV+kXlEpBO8yQvL5GgVeV1fO4qkpuS/tfB
	 FNiSK26GfqpAsCAeibVEFUafxIRRG5B+49qZnj/TdDXYE+MBBAVvCeIDXYadM10M0/yXw
	 0dKrSzaFuLFOAtJrfodZrTwcaufuJfIjBKLYgx+QLLiazavQ2BBu17+mJhqQgfUTSjtHE
	 VH+Awbwk6OoaPdrlHGjwswbBtjN/080BF1yXq3bZDqYdiE2K8DJCYQpevPQrnl4BjpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MMIBkAxh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6A96072317;
	Fri, 13 Nov 2026 16:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MMIBkAxh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788801F000C4;
	Fri, 13 Nov 2026 16:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585985;
	bh=xEtLKOs1x7+eqRbdKdULa0f6eoUmbEPdaUzd6fuCjIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMIBkAxhGsJaZfx1gXcsFHlNQI/6os/wMQZYA1lhMXC+8LB7rJ060M+ytAOA82LAe
	 ElS1fxmxwhWrJCTZFgZ96uWg4ChN0Bc5mSFDEhweqY+OluzjmvrsXzkycnDKjkL+Pb
	 ZE6CWOlGZRJ2F+dbgc3en8rWBDbJ05d2uB9kyRY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 030/686] NFSv4/pnfs: bound the CB_NOTIFY_DEVICEID array count before allocating
Date: Fri, 13 Nov 2026 10:42:43 -0500
Message-ID: <20261113153822.007465071@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <ben.coddington@hammerspace.com>

[ Upstream commit 32f0967ea296d447925465c98e7eec71d4e2f755 ]

decode_devicenotify_args() hands the server's notification count
straight to kmalloc_objs() as the array length, without checking it
against the message that carried it.  Bound it the way nfs4xdr.c bounds
an attribute length, against xdr_stream_remaining().

Fixes: 1be5683b03a7 ("pnfs: CB_NOTIFY_DEVICEID")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
[ sashal: Adjusted context to retain the existing kmalloc_array() allocation instead of kmalloc_objs(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/callback_xdr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index 1aa6a6e14b057..34fa00f1a1c20 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -275,6 +275,13 @@ __be32 decode_devicenotify_args(struct svc_rqst *rqstp,
 	if (n == 0)
 		goto out;
 
+	/* sanity check the count against the remaining stream */
+	if (n > xdr_stream_remaining(xdr) /
+		((4 * sizeof(uint32_t)) + NFS4_DEVICEID4_SIZE)) {
+		status = htonl(NFS4ERR_BADXDR);
+		goto out;
+	}
+
 	args->devs = kmalloc_array(n, sizeof(*args->devs), GFP_KERNEL);
 	if (!args->devs) {
 		status = htonl(NFS4ERR_DELAY);
-- 
2.53.0



