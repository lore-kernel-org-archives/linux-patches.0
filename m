Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619843;
	b=uUgwh8P/US11P+JdL7USJVVaKGOA0umYtLc6l3O3UHy5569YHZg8YswRq8S9dB5c58XA
	 fnZym3Jfb0i5JbiqBL1cjyt6OGXPRQnnpvFkB0VV+1ioakroDh626ycZsWLB27oWJrmi7
	 7FiQcu2+yO7WPxS/ObYPsXqt31fXxlxM5ZmLUjcPPP/xA1orJ43kqJtlT0x/Pgi+5DrHG
	 BlyTunSEdhuDB4XmPdqV8pSy5xefUJnCg8ZJQGNCLbojKJ6l6K3oetyHL9WAvyjdpdrP1
	 HZvsbuoU6dZSJZjCcxuVKJmIhsrrGAoRbM7YRzlECAvRRmlIhVwBvd3NcrFKDemZFGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=53JW6oYLBI3Mx9JVvvfHoBEupxHJYAKEU5StXZSKNTI=;
	b=EwaYHfImMpr+v13/osCUh/50DrmRu2y28TS9F4LF6A4g6vEnLbj7x2hHRYQf+xA+qRyb
	 d2COfxm5MQSY9fj3kmNkkLazD53XMt5aMNF+txhv6VAaU3i4r7qzcsgKyDxF00q86vNv3
	 j0SA8VsujVQ4s4I8EFi9Vzd7Uq7D6ptj/gZaieoN+Z7debGVDcJOu1zzKnz2Y1TGRyBXY
	 mqAuDeBu/KxGgnnU1mGMfLtW7mBpwaCeWPqclQeqDO5yxXXA/FLSzTLKvA/fks8ZLmqwQ
	 PZC0QhPwEpZrp8gsr2G3l/zxeZ33j+yNUDo3HV27k6d69iSrwbKTD52/iWQfmZHqoYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A872NNMl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77F4606A321;
	Wed, 25 Nov 2026 15:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A872NNMl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18411F000E6;
	Wed, 25 Nov 2026 15:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619843;
	bh=53JW6oYLBI3Mx9JVvvfHoBEupxHJYAKEU5StXZSKNTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A872NNMlRPfC8p0KiiLlqIths5wgBbuyLqzqqWqXRRHBEpci1ZFtAiAMb8nDm/9DG
	 iSGP4VDtqcTJxCCTYgAHaPQMG+JhAJOKnbXf+UGA4b7e4NY9wxddQ7Y8CU5Ee+BL2j
	 0iKK64Wezqg7WOvYZGiY7fD5memtige+6PRursYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 7.3 0724/1005] timekeeping: Reject cross timestamps for invalid AUX clocks
Date: Wed, 25 Nov 2026 15:34:22 +0100
Message-ID: <20261125143838.719525892@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

commit 67f1969e29b692ab3cfcc97ba175b9109212de00 upstream.

get_device_system_crosststamp() accepts AUX clock IDs even when the
corresponding timekeeper is disabled. A never-enabled AUX timekeeper
has no initialized clocksource, and a previously enabled one can
retain stale timekeeping data.

Return -ENODEV before calling the device timestamp callback when the
selected timekeeper is invalid.

Fixes: 9aebde8af6fe ("timekeeping: Add support for AUX clock cross timestamping")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261031122218.118921-1-thnkslprpt@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timekeeping.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1598,6 +1598,9 @@ int get_device_system_crosststamp(int (*
 
 	do {
 		seq = read_seqcount_begin(&tkd->seq);
+		if (!tk->clock_valid)
+			return -ENODEV;
+
 		/*
 		 * Try to synchronously capture device time and a system
 		 * counter value calling back into the device driver


