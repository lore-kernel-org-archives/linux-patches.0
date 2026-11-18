Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051918;
	b=tux0P298Q5JlYZr1Vbp6Hg6++k3qCwopiBfQmIm6fkjWjtRFKnPceCC8KMR5H96IdhkK
	 hky34P+6qhjAACxjuccVJe+CMZqOdt8YY95xMCsdASkDrLuIrkMgWQf3FyRz838JmgKrT
	 XoM9Pwg1RsdtkoCbfSBPV4vY83AfceIgCBcAz5Efn4gyY5Lgwun6UaoqMydSB/5DhrEh8
	 F/r79gpJo3lcq7KSFdDc0UYpNiMY0YxoHeBhCX5FFCZX5IEPK8Gg1YRO4WZ6k/k/+FNST
	 /3zVDKYmSoCs3MdtKaFjuFtelxMjqkwvGVBFYlD349eR+RN4QZZGPghjZG5nY+LSpyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051918;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7Pwg6fj3lUpzAreqpAbv0Qv5cWGrW6qQ0jv6DYR8MMQ=;
	b=S5uNalHA9NEdE/D4+w9t+aR13ibEVoixGpL+ZatOX9B05mf6LYLHjn9CfC2nWTZEhpQb
	 Eu6Mh+3OdSL6dr7o5eOka+2aih+BR1ZaMH3rCClXpsrQjW+Fzk18bBJOgCEzCIaTlJmMe
	 FJ4OIr29SdFgDkYhJOfb32T1FCjr5RhhkUKJfm0CwwCiZaoN9NG63A9brS0t3PrLdMl3B
	 7dspzewM/L16UX8ZIQBahHWJnTILdXrx91k2LdVRmbCs95xSxQrdDA+LjyDNmqjcWHgFG
	 GZHIRJp+dPI8mai/bQQnthdCIDAN+1EtZkIsv1Uyf+eBQQqVUBQqsUgLZ3uzrgllk6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="y+bn/gdK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88F7606A334;
	Thu, 19 Nov 2026 01:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y+bn/gdK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE8A1F000C4;
	Thu, 19 Nov 2026 01:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051918;
	bh=7Pwg6fj3lUpzAreqpAbv0Qv5cWGrW6qQ0jv6DYR8MMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y+bn/gdKvwzK85O7UIynGxd5+Sj/FHrBJkO5C82a3gu0Q+QCGrvFdiGNMH4bm6MZn
	 ZNhLpfJbTQCqItp5m2WQjins7GojLKLTtabRGk/2EO0XD4cB7j+u/lg0mxr/sILaWo
	 20hwVGEVuguNtctemplgZux3zU6jMdODrL61a3Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.15 0380/2214] HID: roccat: isku: reject short button reports
Date: Wed, 18 Nov 2026 15:34:16 +0100
Message-ID: <20261118150025.905540816@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

commit 93e5f7f6189af76a2b2e2dfe647838a7b9f99d21 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to helpers which inspect data[0] and, for a
button report, read the complete struct isku_report_button.  A truncated
report can therefore cause an out-of-bounds read.

Require enough data for the button report before calling either helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: d41c2a7011df ("HID: roccat: Add support for Isku keyboard")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-isku.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-isku.c
+++ b/drivers/hid/hid-roccat-isku.c
@@ -408,6 +408,9 @@ static int isku_raw_event(struct hid_dev
 	if (isku == NULL)
 		return 0;
 
+	if (size < sizeof(struct isku_report_button))
+		return 0;
+
 	isku_keep_values_up_to_date(isku, data);
 
 	if (isku->roccat_claimed)


