Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FA81DFE35;
	Wed,  6 Nov 2024 13:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898612; cv=none; b=pPIAdGCkyBu5LcbxF4keI6iuhygZSFlg/ihGxs9qxg/68q2DI0AeCiLfzldbNDNNgXJmWYF8LurYD5R326zB2oOdUkk7pseKeIKlubEkS53d8cDZSHYvfw2JVwuk4F4obW8I+t+MOSIWQ2iUWLCImJQJXFlScnNC3EtCB7Rp2cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898612; c=relaxed/simple;
	bh=pWo+KSoZ+Lqk3+XuDREuQ6bo9b8O/AtZq3yRWDoft3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYrStEFMPiXNd6U3LqjlpH4/Dipood13iUeJLDLeOQHXrYMhF47tS/4qkZOyywRhKa8o9x8t2BQWDVmj1F7cL5vZ9nsxir85oiR91sBaV8YgVdOpC7sQgdL38XVIihjSdg3tMHGBz/hw521xVRaOzrtffeBe2gTw0bKv0cedtq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SmA57OQX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SmA57OQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A1EC4CECD;
	Wed,  6 Nov 2024 13:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898611;
	bh=pWo+KSoZ+Lqk3+XuDREuQ6bo9b8O/AtZq3yRWDoft3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SmA57OQXku53DaEoGdbkG2JVcpr+q4gnUs/Jn4MSHWYCGInw9OBpxvY9plV5vH+Zi
	 3nA3HNeJoweU9LGky5lVYJ4++vxAjLr5ejV7mopv96lCtajZrXyKv7lsRF+FfxQePC
	 G/hNs8kKdjzyZ97OL8EokC9n6DgOFkfZNTTWVoW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 269/462] media: uapi/linux/cec.h: cec_msg_set_reply_to: zero flags
Date: Wed,  6 Nov 2024 13:02:42 +0100
Message-ID: <20241106120338.171602192@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit 599f6899051cb70c4e0aa9fd591b9ee220cb6f14 upstream.

The cec_msg_set_reply_to() helper function never zeroed the
struct cec_msg flags field, this can cause unexpected behavior
if flags was uninitialized to begin with.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 0dbacebede1e ("[media] cec: move the CEC framework out of staging and to media")
Cc: <stable@vger.kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/cec.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/uapi/linux/cec.h
+++ b/include/uapi/linux/cec.h
@@ -132,6 +132,8 @@ static inline void cec_msg_init(struct c
  * Set the msg destination to the orig initiator and the msg initiator to the
  * orig destination. Note that msg and orig may be the same pointer, in which
  * case the change is done in place.
+ *
+ * It also zeroes the reply, timeout and flags fields.
  */
 static inline void cec_msg_set_reply_to(struct cec_msg *msg,
 					struct cec_msg *orig)
@@ -139,7 +141,9 @@ static inline void cec_msg_set_reply_to(
 	/* The destination becomes the initiator and vice versa */
 	msg->msg[0] = (cec_msg_destination(orig) << 4) |
 		      cec_msg_initiator(orig);
-	msg->reply = msg->timeout = 0;
+	msg->reply = 0;
+	msg->timeout = 0;
+	msg->flags = 0;
 }
 
 /* cec_msg flags field */


