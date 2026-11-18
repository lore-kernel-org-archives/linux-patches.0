Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035793;
	b=XwbNhnbwF/dKHmOogp0tNWC7kBvEJLN9DwBkOCAv5vt8vTIOGi4PADI+14AxaLtcWqwV
	 gLYM7UbQHxjaPQxzooZm7Y5TlFNI5ITSYGpuw/mSE4SM9DJleZEItBgUkuqxtqaHwnjrU
	 k2LirBAU9bPfQXfh2IcXZA/g6VD934fqN8mQ4UbA8ftKy0knHiOBmDn1uN/NX5ZehHCzG
	 bs3H9Xy26tUBiPjkNZvK3Ghrn8XpxGbjFIwrdSwVEyIg/mRJ5BAH7Q5seXvutnf9E6+g4
	 w66R2mV3g63QHCtjez2BfbVC3ngAHehBeNqxbsAWoOLoJrQry5bdYXFW8cwUOkk5HAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wHHFa4vYzPNNDkskXK6armrfhfNKuxbadfyPJ+Jwj0s=;
	b=CPRibGXdS5B333B+nFgVp/M9pX7+DKqbt8haoQc8UpsPSkvFqWm8QD0zNlG2xAAwfcCQ
	 0b7ztxxJe/DF5K00aMmCbSDj6hi4Y7kV+LMijbeVGVb57ignewGUHi6e9wC6vGRRrUuBI
	 5E16UAICycV9SjZIYohh3OBgI9FURnEvrqguBR8d8mkZdtgw62MbT8Ql/PYVmOY1tccBa
	 mZcxU4cGA/mTxkpvBTr9KqU6hWZimid3m/5sgviC4OwlL3b9jGujQ7vf2oRnn/FscCsEL
	 HKYF8mSbQ4WhGdcQjbvM9LP1wkUCYOYC4NUO5LjNtOp64BQUhZuKxG/JfqOfmwJJ1Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ksCz0XqK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BADE606A325;
	Wed, 18 Nov 2026 21:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ksCz0XqK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E2D1F000C4;
	Wed, 18 Nov 2026 21:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035793;
	bh=wHHFa4vYzPNNDkskXK6armrfhfNKuxbadfyPJ+Jwj0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ksCz0XqK8U1KRDboVcxFA8/lNOGa/qnbLUy+gTbF0SNwIhjN43u7PfMVI7ZicYrYQ
	 IHZn9n46jq/VqCGxjrDZFXKK9ZYrNvdQy0NbtRjiU/i2zabsq223cYXe/2zn6uGAf0
	 PsWYCv5bGM0tBwifdVtwqwLuRZ/VQAz80NEf2KZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0827/3318] thermal: intel: powerclamp: Reject invalid window_size values
Date: Wed, 18 Nov 2026 15:24:09 +0100
Message-ID: <20261118150343.895926579@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 40989202104e498ff9adfb8c575d6cd159f13988 ]

window_size_set() sets ret to -EINVAL if new_window_size is outside the
valid range, but then falls through and still updates window_size to the
clamped value.

Return -EINVAL immediately and do not update window_size. Also drop the
now-redundant clamp() call.

Fixes: d6d71ee4a14a ("PM: Introduce Intel PowerClamp Driver")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Link: https://patch.msgid.link/20260815090136.88540-2-thorsten.blum@linux.dev
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/intel_powerclamp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/intel/intel_powerclamp.c b/drivers/thermal/intel/intel_powerclamp.c
index 5ac5cb60bae67..e63561173b40f 100644
--- a/drivers/thermal/intel/intel_powerclamp.c
+++ b/drivers/thermal/intel/intel_powerclamp.c
@@ -291,9 +291,10 @@ static int window_size_set(const char *arg, const struct kernel_param *kp)
 		pr_err("Out of recommended window size %lu, between 2-10\n",
 			new_window_size);
 		ret = -EINVAL;
+		goto exit_win;
 	}
 
-	window_size = clamp(new_window_size, 2ul, 10ul);
+	window_size = new_window_size;
 	smp_mb();
 
 exit_win:
-- 
2.53.0



