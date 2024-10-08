Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6691DF997;
	Tue,  8 Oct 2024 13:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393893; cv=none; b=Lu/FjWJnUTbTlz+Qc1IPCfkNRWfqv/rKlnNaDWNf2uprggWg+hcg3s0XvDa2mTAljvj96iC71clwNgqZIfCGN7SMLJQ9nk9EHZBErc0A9kSeSBPsvya1IVnV4kVjhKesydXmZDlbEr+gpOQ0t8eMW8dZkqdjd76HrIzHtEL4gDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393893; c=relaxed/simple;
	bh=Eq4Km9aLj5vUKbakI8dZVp9QbFN+sEE0Pn/o0VLH0Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvA6EMgAUS/MokX6psshXbUgxQcTzuLrCWIFqKUALijSbfsA8AqwcGH+8w3stTx6AIYG+Vzozvk/7nLbnQTJbAYY8PU4Jq23q4SjvD9+iGTY2xb4vDBOp3iSRpVvj15crsZitnAJguBsbEEcfvV2YPzeXFU8myVyx/RHpVs8+Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X8wToNa6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X8wToNa6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A5FC4CEC7;
	Tue,  8 Oct 2024 13:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393893;
	bh=Eq4Km9aLj5vUKbakI8dZVp9QbFN+sEE0Pn/o0VLH0Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X8wToNa65bgw5w1TRQDWcnp7dX74r5BN1c4LEf4z+rUj7CrS9rUuZBx2+Ot/GZ+iI
	 hewraIDJhgmbKgoC3vKujr8bTUVxMymDIKHfqdh/biC6Sif4IqC1Xr+yUnrDZmY53g
	 Yb0Dx7QTwWdNXIjvrzWxYlulCPh8PWWWbOOjitCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.6 285/386] media: uapi/linux/cec.h: cec_msg_set_reply_to: zero flags
Date: Tue,  8 Oct 2024 14:08:50 +0200
Message-ID: <20241008115640.602032334@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 
 /**


