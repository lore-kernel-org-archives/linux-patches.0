Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623285;
	b=4Uhty/4prUC5SfBPDVofO5OtU9F7u4rrl9IcF0YsdGQoZ3iUJVASiReYOxIjz3tZdw2r
	 0D+4qXXLBtGbnMRNUmBS6ZswlXYKHR5UCeqTYi9bPHR9EOb2lCIkl8Owd3kInqtZbXH7Y
	 DSYhpELQMITYJ6p8kI+zb/GkUoPBowo55pPZUjhrzkIwNqvN0BwotVwxfhI831RjfLPpc
	 dFA36uYsqC5VXk3FCNPa+1n8sbOxZEBLuiirqjl9XGF+piLFQ9U1+Hx5LiYuPGA34m5pP
	 pyWU9aWLUS/rJ99kkN813DIuXXpGdD6u7SufTjHkaP21UQ6TLwrJnfGnk6HTFH9NS9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623285;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p8e04RdQPBARzKttA8L/Q/OP8ZdgUGN7lFMELC0lgJY=;
	b=H+TEr305T5vhlNCKXjyNIMUagANBTmg5KbR28MZ0aKilhCezY12Xt8yta5Pkn0ci1avI
	 An3p3QaR9mRXjsWdwaQtJEYEJbuXVHE9OlRDKN/28DnjpANnmC34ekB5WYu/XtZWyHVLU
	 jV2OWgJXjXLQ7QDzaZhxU+BEdRqCIk9nb0d94BsdDmszDGhxfJNwD7yjBN+9ykwfMoF9s
	 HjCYvEn3wJSlDZFKCaIXFZrASi4JvfRa9qZAOjhBSrwotSXx6+P1+AqwRg0Jg86k882KV
	 suRXFbbAg5T9lVhKWNzZxjfrMYytcq49RWSsaLagMvAl9qGcSi9xLYo85yNQYzPpgfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OvRs+lGI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8225606A321;
	Wed, 25 Nov 2026 16:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OvRs+lGI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B6E1F000C0;
	Wed, 25 Nov 2026 16:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623285;
	bh=p8e04RdQPBARzKttA8L/Q/OP8ZdgUGN7lFMELC0lgJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OvRs+lGIXTJKxYz0abIb8eSoY0erYQhNqTABasKScL+HrNF55LMjMI+Vr1F5IU4vI
	 4h9DDqKjnxwLp+L8oDPPWR5s7nAA0BqtQteqlDXPYTleX2pgkBS9RxudCDes9dhSsU
	 TIJJ3YanebcyqiLGT1hgYX/oYNkWvhIgdQaVxqWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Benoit Masson <yahoo@perenite.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.18 809/990] wifi: ath12k: assign device id from the WSI index
Date: Wed, 25 Nov 2026 15:36:16 +0100
Message-ID: <20261125143840.995141718@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Benoit Masson <yahoo@perenite.com>

commit 81986a81f09fae73926c7c44863b335880269c90 upstream.

Devices of a hardware group are added to ag->ab[] in PCI probe
completion order (ab->device_id = ag->num_probed++), which is not
stable across boots. The wiphy radio array is built from ag->ab[] and
the wiphy device is taken from its first entry, so the wiphy sysfs
path and the mapping of radio indices to bands change on every boot.

Persisted wireless configurations reference radios by index (e.g.
OpenWrt/hostapd "radio0"), so such a configuration attaches to a
random band at each boot. This affects any multi-chip group with
single-band radios, e.g. TP-Link Archer BE800 (three QCN9274/QCN9224
radios in one group).

Store each ab in ag->ab[] at its wsi_info.index, which is derived from
the device tree WSI ring and is therefore deterministic.
ag->num_probed remains the group device counter. The unassign path is
unchanged, it already indexes ag->ab[] by ab->device_id.

Suggested-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Fixes: 6f245ea0ec6c ("wifi: ath12k: introduce device group abstraction")
Cc: stable@vger.kernel.org # 6.14+
Signed-off-by: Benoit Masson <yahoo@perenite.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260928213322.98949-1-yahoo@perenite.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath12k/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -1943,7 +1943,8 @@ exit:
 		goto invalid_group;
 	}
 
-	ab->device_id = ag->num_probed++;
+	ag->num_probed++;
+	ab->device_id = wsi->index;
 	ag->ab[ab->device_id] = ab;
 	ab->ag = ag;
 


