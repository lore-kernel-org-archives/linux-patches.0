Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028858;
	b=M3g9Ohk7hB9pufbTFN8NVKHD3OR4gd2E6lCUiiY6E9emFxY1XrDL1YOD4LdZVvKmUbOD
	 Py1JcJ85K9LDXnzLUYiImpWAfN2u7w/x3MTAMNklkLURpkN/7DPA3/fLuhsqr6haMc88z
	 tLsCDHSCo2dkVgfFWJEsOOnC1Ntx4Fx+tjgv9gxGskd5mYpdl1bIttfz5Ylc3MpqsFgEy
	 ZtQLkQfm0qZJ9NoJHpKJUYpwB8i2+QWzzf7iX/lYK/HJLVkJlhohhfRjRcAfkeolPrqnG
	 bmmE+Vvo7d6Y2w3S8CZ/9+yXYvRKzEg41+kuEw557a6EeQXWzreF9J/zvqwwbgsWvuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i7q0DnVAvIvkQyb6hHv8bLujv4Wtz5rJ3uPMeEjl7gg=;
	b=FLaUi/ZNjfKfAx1YdQUL7K9xZZ8kMfkYtPBppzjkz5Ds/cRPcjWlAwf2tdzu//d+NzEG
	 eScVikS7Wuk5QUJDEzh19EKIkZSWH0GMuLefx+gI6xajs3H4VBRngLIVOoVLcFG2k4AAM
	 Jh3f6pcL4IMSXTQX6DOwUqYWABprzCX2pyDSAu2u7CqFE6CEkyt2KNI165wACg/RzwTs0
	 p2vckzqJohO+EQaK8ozMXS1EMOSKgyInQBhvslVTltzxf66DKEv5A2975gvijsewoENwE
	 StmhZaiH9KHyIgq55nCJEH5Ue7jNvGVHj3edEFO0Ovfkky/694t7xd9OsR72wix70cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZLozwqwj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5639760A2602;
	Wed, 18 Nov 2026 19:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZLozwqwj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703F31F000C4;
	Wed, 18 Nov 2026 19:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028858;
	bh=i7q0DnVAvIvkQyb6hHv8bLujv4Wtz5rJ3uPMeEjl7gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZLozwqwjAPt/CFTEuMzhPbV/YIJedx+IhMP+4Qbt/j64CYD+wLqytk6tnE7oetd6q
	 LEzslldyA+4Dj+HtcnWB7WdkknQvtSjQVb6qYQAnH+EfqY9hUhF47cNRKNgoP2CElX
	 /9lEcbDdQxRQPwP+CQ4IxqqvLZKKq15MACRZnOJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0143/1756] gpio: pcf857x: use new GPIO line value setter callbacks
Date: Wed, 18 Nov 2026 15:37:50 +0100
Message-ID: <20261118150013.846519388@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 4027438be823abdcfb50ee2abed06fa4e6af4b7c ]

struct gpio_chip now has callbacks for setting line values that return
an integer, allowing to indicate failures. Convert the driver to using
them.

Link: https://lore.kernel.org/r/20250619-gpiochip-set-rv-gpio-v2-2-74abf689fbd8@linaro.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: ed14364ae8c3 ("gpio: pcf857x: implement get_direction()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pcf857x.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpio-pcf857x.c b/drivers/gpio/gpio-pcf857x.c
index 7c57eaeb0afeb..2b8863eed1d79 100644
--- a/drivers/gpio/gpio-pcf857x.c
+++ b/drivers/gpio/gpio-pcf857x.c
@@ -169,21 +169,24 @@ static int pcf857x_output(struct gpio_chip *chip, unsigned int offset, int value
 	return status;
 }
 
-static void pcf857x_set(struct gpio_chip *chip, unsigned int offset, int value)
+static int pcf857x_set(struct gpio_chip *chip, unsigned int offset, int value)
 {
-	pcf857x_output(chip, offset, value);
+	return pcf857x_output(chip, offset, value);
 }
 
-static void pcf857x_set_multiple(struct gpio_chip *chip, unsigned long *mask,
-				 unsigned long *bits)
+static int pcf857x_set_multiple(struct gpio_chip *chip, unsigned long *mask,
+				unsigned long *bits)
 {
 	struct pcf857x *gpio = gpiochip_get_data(chip);
+	int status;
 
 	mutex_lock(&gpio->lock);
 	gpio->out &= ~*mask;
 	gpio->out |= *bits & *mask;
-	gpio->write(gpio->client, gpio->out);
+	status = gpio->write(gpio->client, gpio->out);
 	mutex_unlock(&gpio->lock);
+
+	return status;
 }
 
 /*-------------------------------------------------------------------------*/
@@ -291,8 +294,8 @@ static int pcf857x_probe(struct i2c_client *client)
 	gpio->chip.owner		= THIS_MODULE;
 	gpio->chip.get			= pcf857x_get;
 	gpio->chip.get_multiple		= pcf857x_get_multiple;
-	gpio->chip.set			= pcf857x_set;
-	gpio->chip.set_multiple		= pcf857x_set_multiple;
+	gpio->chip.set_rv		= pcf857x_set;
+	gpio->chip.set_multiple_rv	= pcf857x_set_multiple;
 	gpio->chip.direction_input	= pcf857x_input;
 	gpio->chip.direction_output	= pcf857x_output;
 	gpio->chip.ngpio		= (uintptr_t)i2c_get_match_data(client);
-- 
2.53.0



