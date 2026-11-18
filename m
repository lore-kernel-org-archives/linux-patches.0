Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041663;
	b=Upzh8zBIGMq+1J1GN/6C1xxnVf/8IUWadJAlXCvkoizSlgrbP+nJSunC9RRQw4q3f2rZ
	 9LYAkAEazuiRjYlmWPCwYNeohZyx86ipLetKa9gsk7LT1oQgx0lcqcNJ8NuS9amUjIW2U
	 0uK2bnSyWE3MCg9Lyd93IZXsLeJz/mIGacs+gfJdMW7xMP19r38S862ud44otUIuAF6dC
	 jWadC6U/esgw2mwZk4wDLepTFjSdyyVQAmr7te4NcpyDQ6Tne5mmHttUHPrLjwdrvz2j5
	 uyfO0YbaaFV+KPZh+ejL4weKtaAALUFXTw5sjs0icFYLOc8bj9iUoWvexQF5pjMxbqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041663;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Y7+QVgRqkCVtQC8J0Re63RzJehPf9iaRhkLjgf9xM3g=;
	b=StxQX15LlWwXr6VRh6C2yGeZW/CLrM1QGBTWdYzj3EbjH6GIqGk4aeDUp+SqxGAyU1s8
	 54NiyAaRy0nogaQCmNypv11PvD/N+kop0bollxKM7hKjdvWhbnyveMeohNfNnZmpUY3un
	 v7snGcilWSZsO+Ro3QftQ59MmreypBEF+KB+Tj9WJ0QOt2UdY5DcFu32Y6eXFr8zUiGlD
	 gfv9uwoMPJbiJgbbXTyXXCINiZcxP5EjHkfThm1+78Rk6dHtW83gTEPWynjlvWlpCz5DW
	 5zbOGSwAp7rrNU3o7TvTPJFE+3TyUGtc4ipMO31MSYCWaSdYPModhfLIMGSHOO6Kgqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xXQPRwja;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9037C606A31C;
	Wed, 18 Nov 2026 22:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xXQPRwja
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2901F000C4;
	Wed, 18 Nov 2026 22:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041663;
	bh=Y7+QVgRqkCVtQC8J0Re63RzJehPf9iaRhkLjgf9xM3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xXQPRwjapacmRnJ8Gmwjsp7GCxsdT28t1o5iVzqMvVSvtIG+ra+tk8xe7Dr8hlmNU
	 4LK/TsmduyORcg2QQcA2KoC325anJKnYoDQO0+HinWqkpclfet4SvOFMaWghUOX8/u
	 aSex0EVx9Kg5M92mlxnqNZWJmXXAelJwR6GocdAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2852/3318] platform/x86: hp-bioscfg: fix oops on short integer attribute buffer
Date: Wed, 18 Nov 2026 15:57:54 +0100
Message-ID: <20261118150446.160711505@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit fd7545cd398adc09ec2f9b603d72671560ee6bf9 ]

hp_populate_integer_elements_from_buffer() ignores the return value of
hp_get_string_from_buffer(). When fewer than 2 bytes are left in the
buffer, dst_size is 0, kcalloc() returns ZERO_SIZE_PTR and
hp_get_string_from_buffer() fails without writing to it, so
kstrtoint() faults on address 0x10.

Return the error instead.

Compile tested only.

Fixes: 6f2c06d5a467 ("platform/x86: hp-bioscfg: int-attributes")
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://lore.kernel.org/all/20261007134711.473857-1-meatuni001@gmail.com/
Link: https://patch.msgid.link/20261007134711.473857-10-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-bioscfg/int-attributes.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c b/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c
index dec89c391c06f..d71ec82dbdd95 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c
@@ -334,7 +334,12 @@ static int hp_populate_integer_elements_from_buffer(u8 *buffer_ptr, u32 *buffer_
 	// VALUE:
 	integer_data->current_value = 0;
 
-	hp_get_string_from_buffer(&buffer_ptr, buffer_size, dst, dst_size);
+	ret = hp_get_string_from_buffer(&buffer_ptr, buffer_size, dst, dst_size);
+	if (ret < 0) {
+		kfree(dst);
+		return ret;
+	}
+
 	ret = kstrtoint(dst, 10, &integer_data->current_value);
 	if (ret)
 		pr_warn("Unable to convert string to integer: %s\n", dst);
-- 
2.53.0



