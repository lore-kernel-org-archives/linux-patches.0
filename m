Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049741;
	b=nXbrNQ7aNs3x3aVCAgcZ9ggc9IQksKiAxqtJKwqWAxWCmatgoc03gtkVHPdekLxXyDgf
	 OCs4kQFV7EH8Ry8aikPYNTb5AxlkOVQ5ZAjGztnlo3JEmzaebP0X3EifeJDyws17ceaaV
	 0kPbfwx8OJNVayv1Ql/S5y0hoEQ3XHtS5OzU83jUj3KYJ/Pfl/lqyQvP2KdGkM2dqibcv
	 xwXaSUmL647MYBk3nqh9JxEUvo8/VobkLcnf244wcgVUHSsFTEZiJeO9Gzu16r3WVkx0B
	 R5OSjf/IjDkylVPkVWl7s0Er1QB93k5US6ufJiZnIpfS2FdoPLkezokdNEMqOYicy7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049741;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gYKMYMbuIKW4fq/OsuzxLIODNh4mlle9mX1KAtNDKxY=;
	b=HSqWD1HqX4/Z3W4+5KZNjKDx5POMdPfHa3JpiYJE+sIQAOvR10xdetst+wtcJZ+WgtQ9
	 A2kqtbcyMH+JUH9r4193IGX1kN5uGljJsTk98tsWz17Ca2NLsYGRf4+1bim5U3Fn+TwEu
	 BoJW1l9lRHFvRabxHyr4I7I9aEcemR3Y8dMmWpr3Nky8KxF2iAUIiYDp5HiJGDRRqeqXx
	 eCSOcW1O6yCtLWzvi/yuurzsM2ZduGqUqt1jDm2mAojsDRsRGW65s7yfLmjLS5XH+UDfS
	 NDN7WwJRVXM2Y3mCgT4oM8tnILXF5RQLuwEF5ZpTCNrkOxw+ZXMqS+AKlee/0rF8Clw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QmXPNYrH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C4A606A31C;
	Thu, 19 Nov 2026 00:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QmXPNYrH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7091F000C5;
	Thu, 19 Nov 2026 00:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049741;
	bh=gYKMYMbuIKW4fq/OsuzxLIODNh4mlle9mX1KAtNDKxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QmXPNYrHi5KP7ZTK/sliEEJYGpez7gwPSvUHOomRzgkE3rdY8jw7XErFI3sj6YUcg
	 1xItI3z8AhupnwwLIHiq5m/ZyOuKen+2YeyGe1+T0wM12TvYsn3UfN766ZGXgOdKSl
	 UK3ykdFdfGRO/gkkL1t/YXfiNcXRdHdhuIdyBOLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2461/2857] thermal: ti-soc-thermal: Fix the return value in ti_bandgap_get_sensor_data() kernel-doc
Date: Wed, 18 Nov 2026 15:58:15 +0100
Message-ID: <20261118150330.179639643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 82bb005cd9cf5a9df4cfe4a52db90346ac5fd17a ]

ti_bandgap_get_sensor_data() returns an ERR_PTR() if the bandgap
instance or sensor ID is invalid. Otherwise it returns the stored sensor
data, which can be NULL if no data has been set or the stored value has
been cleared.

This mismatch was already present in omap_bandgap_get_sensor_data() when
the driver was introduced in staging.

Document the validation errors while retaining NULL as a possible stored
value.

Fixes: 8feaf0ce1a04 ("staging: OMAP4+: thermal: introduce bandgap temperature sensor")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260912062252.42762-1-kmehltretter@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/ti-soc-thermal/ti-bandgap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
index 13c5166b3384d..92d868ea50821 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
@@ -576,7 +576,8 @@ int ti_bandgap_set_sensor_data(struct ti_bandgap *bgp, int id, void *data)
  * @bgp: pointer to bandgap instance
  * @id: sensor id
  *
- * Return: data stored by set function with sensor id on success or NULL
+ * Return: the stored sensor data, which may be %NULL, or an ERR_PTR()
+ * if @bgp or @id is invalid.
  */
 void *ti_bandgap_get_sensor_data(struct ti_bandgap *bgp, int id)
 {
-- 
2.53.0



