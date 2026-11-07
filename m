Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063310;
	b=m/9DiXnxwJqkqgJKV9LM9B3PCLMTiBQgFE08tlGcwZ3S8j9p/jdrk8MRZesDGCcg7rg7
	 PDFAgwvLVx4NRXKqkTapxJ2UBUYCKlVp24PtiQLs9dTCze4C3kp6cHIpOd3PyKPAgJnn7
	 8TuXx1sxow605D4ZnM9o1LNv6NKfHVUjjLtfjDNUndlKPo/iAtkmUx6okUQaDs6LzYUqF
	 Qg10lq+cQR6a1q2XWkRlij8fQ4C0P2pOIwzTAmcnmtMuzfA73Jwo+wYWpaY9aNz3MZEnV
	 fN7zOquW5LKWA/Pwr5AP04CCQgRdFu3XBOk5q/iNx2n+ua/nznnYl+j+Jvo5rcq4Edg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063310;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=WXpP9A0MMY1NLy3/4ukPi491erQrm8qq5fryvNXt12M=;
	b=2JKY4svEnZ5s02wW4bs2gXyKVjbf31X36oKRIvwQn5W7L7TkOzRoy301ys7woZj7PP56
	 GDG8QvPoKJR9NtrJmKFz/S0OSJnItJVABta5OpNaOfB/YXk/dkvMg3GCGoackbLdDAlUx
	 aUXKB/B8HKEYF6LR/J439ZiTE3x7WnccXTPVKiEG9UFeMY+GLfLWiC2ZN4va0sCYjM2Nh
	 rKTbCqID09EOaZNu9dPNnzSVouZ/RuGjG2ZGBW7cYv8pvFNjkMBWkpKrzegeh69QcXDj5
	 jG94ZsKs6ntqsM8Ilyp7Xp+kZq2dFkE5ocr9SLTcrPuAGEfiCvSTMmRkztqufYuEgsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="d/KzITgX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1813D606D828;
	Sat,  7 Nov 2026 14:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d/KzITgX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1891F0089F;
	Sat,  7 Nov 2026 14:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063310;
	bh=WXpP9A0MMY1NLy3/4ukPi491erQrm8qq5fryvNXt12M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d/KzITgXTRjcpg8RyIr7KPqjyZi45CoVBL0QKkEAM8zIlBELyV3izmj22120JqJgS
	 ApnOGEpHWNlgL343nSwJhhrCFWJ8ZuCodZo27s+mbeiveyhv6Ci8MxIXlR2QICFMge
	 UHkybi1Q30xBHvXEWT25AgUZN34c96Z+kVRv0iiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yijia Wang <wangyijia.yeah@bytedance.com>,
	Guixiong Wei <weiguixiong@bytedance.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 498/869] platform/x86/intel-uncore-freq: Continue restoring limits on resume
Date: Sat,  7 Nov 2026 08:53:00 -0500
Message-ID: <20261107134910.532888135@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixiong Wei <weiguixiong@bytedance.com>

[ Upstream commit 38998529f45c02edcf96b0a3ddd3c83de6d11bbe ]

The PM notifier iterates over every uncore frequency instance to restore
user-configured MSR_UNCORE_RATIO_LIMIT values after resume. Entries that
have never been configured legitimately have stored_uncore_data set to
zero.

The refactoring that split common and enumeration code changed the
iteration from active control CPUs to all allocated instances. It also
changed the skip for an invalid or unconfigured entry from continue to
return, causing that entry to terminate the entire restore operation.

On a multi-package or multi-die system, configuring only a later instance
therefore leaves its limit unrestored after suspend, hibernation, or
restore if an earlier entry is invalid or unconfigured.

Use continue to skip only the current entry and restore all remaining
configured instances.

Fixes: dbce412a7733 ("platform/x86/intel-uncore-freq: Split common and enumeration part")
Cc: stable@vger.kernel.org
Tested-by: Yijia Wang <wangyijia.yeah@bytedance.com>
Signed-off-by: Guixiong Wei <weiguixiong@bytedance.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260929163133.14326-2-weiguixiong@bytedance.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
index 0dfc552b28024..3836d76943f5a 100644
--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
@@ -211,7 +211,7 @@ static int uncore_pm_notify(struct notifier_block *nb, unsigned long mode,
 			struct uncore_data *data = &uncore_instances[i];
 
 			if (!data || !data->valid || !data->stored_uncore_data)
-				return 0;
+				continue;
 
 			wrmsrq_on_cpu(data->control_cpu, MSR_UNCORE_RATIO_LIMIT,
 				      data->stored_uncore_data);
-- 
2.53.0



