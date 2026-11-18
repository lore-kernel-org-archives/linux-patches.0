Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058089;
	b=zJe1LgIwszcTUiY4vX7a06x0CGqdD+wudfkjJ2QLqPzqx8trCdZolQr135sygGPLzC8J
	 trV2i7NIvs7/EGgCEitJi02sjOupI9l83xB0HGuu1BX9gvJFZvi/zPWn1WNna0bnnrO9Z
	 r5PYlucIfK48zMSLYtVLwpEZlwwqM1fwxhNuBhcJRlFo91EDM/+Gss9YQyVYv8+sNGLUO
	 ldH+B47a5E2LlH6cS9iiDJpnuL2YbYZpZBuefcar7JfgPPFnui1+SDZbxUFK4CeWJGjGn
	 bLYtaQwpqqyqg/YaA/6Kts5YUMnEB0ySWU8o4WMMUtTeov4fmKo7kznZbZJNntIj5Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QneaNld40T8dqMbGZByKAvRi0QqfYItg+exf1XIQJA4=;
	b=v+R668+Ygp2ZZ8Vhw4mZfMiNuvTRjnSYBUSiivPKJm45vzC/x9NgUKdWyB60P/0XD212
	 jZN5CBoTEQSVkcorPgkf45Bj60x6nAwEtfoR88OnJGMV1g6KGOdziMIg/CnWfan+pYCUs
	 Z5myjlLLuJ2OQVERcch9BviOf9gRBHv0izCy39Iwb+UBxsGEAxbqHzFAwsDg+/SxR3E+y
	 xiTtytlncDOFE50dGos0OA6aMbUcXAK9/seDJrBxgjrfGV/Jb2dz9gmbMzqE+CMna7eI6
	 JFItLDEi1ZzNsqvgUyUlJVX207MicZ0dt0cSPz6UXhIOJCPwUo/4elbjkHoRo1Xmq+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v4oBk2A8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112E0606A31C;
	Thu, 19 Nov 2026 03:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v4oBk2A8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D251F000C4;
	Thu, 19 Nov 2026 03:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058088;
	bh=QneaNld40T8dqMbGZByKAvRi0QqfYItg+exf1XIQJA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v4oBk2A8GT3vJkejZn6z+/jKAFv4rUInGFfS2ccfXmJoI0x3fkalRbqNI1WULuz4h
	 d+CxrFRI6TYxjeyDQqvG5na3o/Td9Ii0xFFYnG9wBbuHMthhEUkpOWKERGa869QnJG
	 aCKX4woLMt06yQqbTVhIF2vr6biae4T1ABi2yS10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0362/1848] thermal: intel: powerclamp: Reject invalid window_size values
Date: Wed, 18 Nov 2026 15:40:00 +0100
Message-ID: <20261118145928.279335048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6e7c230d308f7..1ec805d8dcd23 100644
--- a/drivers/thermal/intel/intel_powerclamp.c
+++ b/drivers/thermal/intel/intel_powerclamp.c
@@ -154,9 +154,10 @@ static int window_size_set(const char *arg, const struct kernel_param *kp)
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



