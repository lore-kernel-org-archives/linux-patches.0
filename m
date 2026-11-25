Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617963;
	b=hmS0Qv66DtB3g4k3U5+UnDqUC1nXjyAZzkH5JvQsxsXVHdJSdQq/wrrGzCYh8eFQ8n+8
	 3I/OYi2av+cW5o32sORL6Bq1iCOhpvbNPHq8Vum/SxSD74Di7aIiDRJR5pHjN+q6bvTms
	 p35GeGqi9V906ypZex7BP+c4sV0Pcj0c8wiV48hguhWytkyuoK/CdiUNbA39dWmqGEi8b
	 x4y0SxKw69e+Js8c16ZLGaytjc05ybT6T4tFPuTa2V1feOhgnLTgW0jbz+8tuOKmPjcMO
	 /YXa7jqkcTrO/dFGIhM6e9J7SDvAe1sjXVXXSEXj1UGvQ/3WtKrXjELPwy0OfvJq4rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617963;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=85RphFgUW2eP/Z4TAIlPRV+JdkPTrX8at9WbAeGJoX0=;
	b=CfrfAvo89MwzW7UNTI6GEO6DdBJSuFRIGZ1GNTu19EBO9/+UOnUnzVb0+EjQz1A0WDn5
	 bCkAapqWlSpCPN2pTt8AwizP3ez6OElMH5qDtEMIiiZUpkd/vHUr447KWx63jfhlvbRKe
	 +zTwJSbS+rwhHDPDnEo19boK9PiYjYU3ZafcwD1z0ElI82EaEIGg45EtYO3hBvBAQiEj9
	 uoAR/E3YNimLI5wec6aVBOVzivLc8GNREMC4YvlnxbHvcEYLx6aiaXSV4GedZ7N/vrsXT
	 vxkSCVwCHnCOJR2eA3y7510eMhBY1oAJL40+M0blWhRhslA5BSb7GrxeW8A6XOCd4bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YfEBYH0d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43DF606A31E;
	Wed, 25 Nov 2026 14:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YfEBYH0d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16D41F000C0;
	Wed, 25 Nov 2026 14:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617963;
	bh=85RphFgUW2eP/Z4TAIlPRV+JdkPTrX8at9WbAeGJoX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YfEBYH0dh/cjewfvfUkbU+JC8pgyqY5YZ/gcgZj4hpMnWU9oeHy6sXyUgjbVIwaRu
	 mg2Q5qSaYTJm3Om+0K+wll1dzAQHFWInjC+Ci4KtJzF67e1Rs8CEAFEaLDqw0S4gU7
	 eotSsExDgujCCa+cqZg1GuHATAgF8sHNartGSbRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shengchao.guo@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0131/1005] gpio: shared-proxy: Drop the vote when switching to input
Date: Wed, 25 Nov 2026 15:24:29 +0100
Message-ID: <20261125143824.807928341@linuxfoundation.org>
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

From: Shawn Guo <shengchao.guo@oss.qualcomm.com>

[ Upstream commit 925409db963dbae4628d522bc6b14985e749c08b ]

A proxy that is the only one to have configured a shared line may
reinitialize it. When it sets the direction to output, the proxy
resets the vote tally, but when it sets the direction to input, it
leaves any vote it cast in place, although an input line carries no
value.

That vote outlives its meaning. When the consumer releases the line,
gpio_shared_proxy_free() tries to withdraw it by writing the default
value, which gpiolib refuses on an input line:

  Failed to unset the shared GPIO value on release: -1

This happens, for instance, when a consumer votes for a change with
gpiod_set_value() after setting the line to output and then switches
it to input.

Clear the vote when the proxy reinitializes the line as input, as
the output path already does. No other proxy can hold a vote at that
point: voting marks a proxy configured, and a proxy that frees the
line drops its vote.

Fixes: e992d54c6f97 ("gpio: shared-proxy: implement the shared GPIO proxy driver")
Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Link: https://patch.msgid.link/20261028123448.510401-5-shengchao.guo@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-shared-proxy.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpio/gpio-shared-proxy.c b/drivers/gpio/gpio-shared-proxy.c
index 75d0d617941f2..b2f2301e9e64c 100644
--- a/drivers/gpio/gpio-shared-proxy.c
+++ b/drivers/gpio/gpio-shared-proxy.c
@@ -211,6 +211,9 @@ static int gpio_shared_proxy_direction_input(struct gpio_chip *gc,
 		if (ret)
 			return ret;
 
+		/* An input carries no value, drop any vote this proxy cast */
+		shared_desc->votecnt = 0;
+		proxy->voted_change = false;
 		gpio_shared_proxy_mark_configured(proxy);
 
 		return 0;
-- 
2.53.0



