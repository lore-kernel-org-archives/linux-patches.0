Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035249;
	b=QfF5+aoKGSKh96DX+dWF/ZsJtlDhq9xThZUk/OspSovcNdN8iVOEneBTAxPcVTmpE+Hr
	 g2WLi0jbIIkLhDOUU7cKkz+4po0D0Ed5JJhC0VaQSWs7QByF04HfttpmiYKzDDhpfA7Xq
	 +18KvyInoIZdbD56zBGw37J8BEOu/e2822TelrsZqwVLCw3ueWk417OExc2GOd7+5HU2N
	 SJ2zCkF7rKxj7MT6l6rHgLa6ZC/M9E1CpPxk1Az3rltOdrK6YFx+Pp2Y3M4Nt3gTZ6giF
	 2SOw95kAl0mDMVkHvh67YdSZ8e1h7qLvn18rlGLNLQdKO9qu1X1+FGCpveoejuMTNDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TYYqcUCRp9M0w9RlJCbTGPjCL+BvCSx/ZkZ9JpowBlI=;
	b=v1IlCq3SqnMFL4A2Sve4nNIRawqbsRv/7lW49MSUtPhaHHqIRRo0Pj470wycW1v4CIBc
	 zcl7vrzawQ4hL2qOik63yn95LNToMuyMQcRKZBlPrS7OXY4Cszh367fy4RACSLIbjTX9B
	 sHMwk5vv/VN8kWN4VuJKvkpNPANIa8afgDZCVbnDERKOBjFbpEhBdZH6dYIqXo3mrZ8LR
	 5S4/9E/B+VOvL525i1GC4GXCmYVbTWcl/c7Rs5sofPzSZ1Wx4Ns+lUhTymLkeQWWIob2v
	 dWx0xs3ejQAez557oPlgn81ryBCI9kIvAaudUpfYhoqHMhmbuaKCDWF8o4M0DPUwmAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aj5oCQfc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC016606A320;
	Wed, 18 Nov 2026 20:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aj5oCQfc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505D71F000C4;
	Wed, 18 Nov 2026 20:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035248;
	bh=TYYqcUCRp9M0w9RlJCbTGPjCL+BvCSx/ZkZ9JpowBlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aj5oCQfc36Wj9bHAQI+xhkBgCkVlMmFE8/OB+2U1WC9hZeV1YxYDJmY83+eww4lVJ
	 3RZyCMZz7rtqxsJvyIxEKqmRksVbR7jgspVgLMj5/KZW5y5VZVhrWfV+vkbiZsuBAC
	 E9c/mjymGOU8T6a9n/RSFZhVP0Nz398P7rYc4EM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 0659/3318] xfs: fix xchk_stats_estimate_bufsize to allow for the trailing null
Date: Wed, 18 Nov 2026 15:21:21 +0100
Message-ID: <20261118150337.825474791@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 6b8d60784b61a17bd591cb4c6e8aa9ed29c24f5c upstream.

LOLLM complains that xchk_stats_estimate_bufsize underestimates the
buffer size by 1 byte because scnprintf wants to store a null byte after
the newline in each line.  Each call to scnprintf overwrites the null
left by the previous call, but we still need the null byte for the last
line in the file.

Cc: stable@vger.kernel.org # v6.6
Fixes: d7a74cad8f4513 ("xfs: track usage statistics of online fsck")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/stats.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -158,7 +158,8 @@ xchk_stats_estimate_bufsize(
 		ret += field_width + 1;
 	}
 
-	return ret;
+	/* null byte for scnprintf */
+	return ret + 1;
 }
 
 /* Clear all counters. */


