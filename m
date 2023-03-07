Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40834BA44
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9999DC433D2;
	Tue,  7 Mar 2023 17:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211604;
	bh=iz+cM73n11GcC8NPjrwxOQLmGFQko/mYr58y6SQbwTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gk3LUIPr/vd6ZuWWqUvMkS/RXwfqBX9GOiCkwc1VCHQHfr0/myU5M4WVQNcCwxj/Z
	 D+JPsCpMMVYqxWAdNRhYnAO8vj0qU/LpZiVkS8imWwTAufbjPTYXFLrtWseUVT31sP
	 +vSFKRbMQQDsvgJNsS3Hn76nKH3QUqiQ9EsDTd1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zev Weiss <zev@bewilderbeest.net>,
	Guenter Roeck <linux@roeck-us.net>,
	stable@kernel.org
Subject: [PATCH 6.2 0916/1001] hwmon: (nct6775) Fix incorrect parenthesization in nct6775_write_fan_div()
Date: Tue,  7 Mar 2023 18:01:28 +0100
Message-Id: <20230307170101.809651907@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zev Weiss <zev@bewilderbeest.net>

commit 2fbb848b65cde5b876cce52ebcb34de4aaa5a94a upstream.

Commit 4ef2774511dc ("hwmon: (nct6775) Convert register access to
regmap API") fumbled the shifting & masking of the fan_div values such
that odd-numbered fan divisors would always be set to zero.  Fix it so
that we actually OR in the bits we meant to.

Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Fixes: 4ef2774511dc ("hwmon: (nct6775) Convert register access to regmap API")
Cc: stable@kernel.org # v5.19+
Link: https://lore.kernel.org/r/20230102212857.5670-1-zev@bewilderbeest.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/nct6775-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/nct6775-core.c
+++ b/drivers/hwmon/nct6775-core.c
@@ -1150,7 +1150,7 @@ static int nct6775_write_fan_div(struct
 	if (err)
 		return err;
 	reg &= 0x70 >> oddshift;
-	reg |= data->fan_div[nr] & (0x7 << oddshift);
+	reg |= (data->fan_div[nr] & 0x7) << oddshift;
 	return nct6775_write_value(data, fandiv_reg, reg);
 }
 


