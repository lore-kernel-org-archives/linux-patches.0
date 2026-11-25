Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619840;
	b=b9EHd2dHVDOfa3Ir8+jatS35v/jl3rDl8epsBPg8FWkNcGQjm0QBANo640xElEOsSp9P
	 ArGNh1nG+feBTzrnCgvfnIRgpeyDdf2VbJVOqss4kna6kg8mJHzByHxE9ncG/Pd8PFx+7
	 86ow4undoxkcHdhx/RH28nWjZIIpUXw/hUTiP1rISc4HLsJdvQW4JZeQxoIy8Zzrk08oR
	 OZPJmgFLlLUmUXwHpxbqLPaU+BiU5ZWgZb+HWDoAr5g8ysrMiYfFzcYfj9g8s8l/3kzWT
	 YJqkh3+PJpa69orrh+FVXosqGAgaNNDAVLhCp7QnAPGe5EKZYwJcHO/QVEMDB/YTZOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lb6vniZErJRrqqxHsLsU1Hz+WUCuTLwR6+rxQWF3uVI=;
	b=4AEcEfnSwVd5R5HRtr77c2AJgMhmW/eaGQxwVOuaCRTMwElS0kx1Syay+H43H7s9bKul
	 lcAGk2PfBW68gS36xnUqoogdgMn6idNfBU4tiTJA6GylIi8y6RgpMxjAt/jN/ZNfrGvo5
	 aBletcE4J9sjAGZnnRdzTYNTdcmcRRtFPLYrJL53f449OJPrkyZHJy6g4lGApARFPkeAb
	 rylAtspsGEP9tVB0EFQTWJifjTDyJMqsgpZQmge9S6Hi50x/p9YGnNKn/Mg6g/ZGrWmiy
	 u+sbHMG9wEHn9VYjbDgHlnZJ02B+sEkBCu+2lriTh5XSTDy6HzVQH2DM3tKoJqFbwGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wpo37RnZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE79606A31E;
	Wed, 25 Nov 2026 15:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wpo37RnZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5431F000C0;
	Wed, 25 Nov 2026 15:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619839;
	bh=lb6vniZErJRrqqxHsLsU1Hz+WUCuTLwR6+rxQWF3uVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wpo37RnZi3Lhy2M/wwMFt5hVi/mCsTtIu7CzWJ/J6/D6Q9becCtV49jlPoeFz9M/E
	 9+NHNo1qD6jOaEgTGBQNmt23p8uFp1iEWgvG1p8WIyXi5P6j7rwAdpXjzbl0sGQaYK
	 XUC8YuJ2xX5vaxgERokYkiX2FOsf8iWznOEtmqrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	John Stultz <jstultz@google.com>
Subject: [PATCH 7.3 0723/1005] timekeeping: Read getboottime64() offsets under the sequence counter
Date: Wed, 25 Nov 2026 15:34:21 +0100
Message-ID: <20261125143838.695991421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Hungyu Lin <dennylin0707@gmail.com>

commit 385b5ec1f31dd39297578eed42be74b07ae74017 upstream.

getboottime64() computes the wall-clock boot timestamp from offs_real
minus offs_boot without checking tk_core.seq. A concurrent timekeeping
update can leave the reader with an inconsistent pair of offsets or,
on 32-bit systems, a torn 64-bit offset, producing an incorrect boot
timestamp.

Read both offsets under tk_core.seq and retry if an update overlaps
the sample. Convert the resulting local value to a timespec64 afterward.

Fixes: 7c3f1a573237 ("Introduce boot based time")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Acked-by: John Stultz <jstultz@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261030054227.35453-2-dennylin0707@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timekeeping.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -2698,7 +2698,13 @@ void update_wall_time(void)
 void getboottime64(struct timespec64 *ts)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
-	ktime_t t = ktime_sub(tk->offs_real, tk->offs_boot);
+	unsigned int seq;
+	ktime_t t;
+
+	do {
+		seq = read_seqcount_begin(&tk_core.seq);
+		t = ktime_sub(tk->offs_real, tk->offs_boot);
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	*ts = ktime_to_timespec64(t);
 }


