Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831843;
	b=X5EtgkiJu7UFG6tUEo7AQxpIeKl/vegh6hRjwT1A/nQS3xJNH9vglIIyEF6qF8ALle/1
	 rXejyNUFZKZiJo75Gzs9AXAsEPnGnCazjMWo2KTSpgEhKoyn3QBlt9ytfeMGu+RzpQBou
	 Tb/t50cDNYthvlEielXg+d1RYGRJSikSjhVzOM3u3NmMRTZbzpp6md7DHjDCMgcPk/HZ7
	 /6fmZ8ArotNFQIVqd/tPpefITR92u3we0iLfH/8keMon31JfK8qjjvXFMMtGhl+/RCsuL
	 r6XgSfR8eUXTU6cyvFexgnt8QS9wQAv2cLNR0hDRDV8sQlPZPOj7iO8gXy+j8+jnz4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pt6PcVRkrkGOP+oJij400MQ+q2Xk5y4Bmio+LmLgV/A=;
	b=osSkWjzVNV43Pd5VknBOciySrZUCGMn7MyZOTUgYaqDQZQC2HegDbDzV7lZFrDZzVcwS
	 2Z7toGuLfMYIYaTYFGdoZYNXENPCw8HX8tfmK8ztDt/eFAbFRrtak9u/ex8X5MgTaJ2xf
	 khJhpZ0MaV0RuiMeEOZMla8iG5w5/DqN64hVf+Vx7aMJ6NfC/CEEF2SYj8waQMkY17Myp
	 qHNgNmwSc0h33trEZH154yZAKc9Wos5DSTxlwzTWP+OaqaVS6qDYaGiiHA4i49FM1dKG0
	 b5ErNIQqX4vh3QJNX5hU58nEOkZCxVFbyYsYaJcg5nKqkJtusUdsy6DNjQ7XMQgP+5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gh+RJYoW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A82606AB17;
	Wed,  4 Nov 2026 22:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gh+RJYoW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73881F000C1;
	Wed,  4 Nov 2026 22:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831843;
	bh=pt6PcVRkrkGOP+oJij400MQ+q2Xk5y4Bmio+LmLgV/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gh+RJYoWrMXBU4IDrUQy/4uImpUu/7uRbphOl5do0SRtZLiCAexfZeTISez+vVZcW
	 C2AZ25jjS35arwlAkyh1cNHD/i6ZuOMfncE4jWKH3CL8wLXPjnImWjfMDfcJD1+9hb
	 90eAoiz2MOv9X6rQdrVy2VU4WlfvGje0nXCDg6L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 0949/1005] HID: cougar: reject short special-key reports
Date: Wed,  4 Nov 2026 16:11:22 -0500
Message-ID: <20261104211109.690405789@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

commit c6c0df8a4b73a0d563c5e64de640ef5ff525fc82 upstream.

The HID core invokes raw_event callbacks before validating the report
length.  cougar_raw_event() reads the key code and action from offsets one
and two without checking that those bytes are present.  A short report on
the special interface can therefore cause an out-of-bounds read.

Consume reports that do not contain the action field before accessing the
fixed offsets, consistent with the callback's handling of other reports on
the special interface.

Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw_event length validation to hid-asus.

Fixes: b8e759b8f6da ("HID: cougar: Add support for the Cougar 500k Gaming Keyboard")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-cougar.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-cougar.c
+++ b/drivers/hid/hid-cougar.c
@@ -270,6 +270,9 @@ static int cougar_raw_event(struct hid_d
 	if (!shared->enabled || !shared->input)
 		return -EPERM;
 
+	if (size <= COUGAR_FIELD_ACTION)
+		return -EPERM;
+
 	code = data[COUGAR_FIELD_CODE];
 	action = data[COUGAR_FIELD_ACTION];
 	for (i = 0; cougar_mapping[i][0]; i++) {


