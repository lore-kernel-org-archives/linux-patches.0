Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BB61F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78A5C433C8;
	Fri, 21 Jul 2023 16:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955750;
	bh=AHD9iKyrhhNmOIaWLq1ryY6tiVk8FrAU5k4D3C3iKbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZfwWI6h8ccgklVJhPzgK7x1OgNSXIOq6vAxzZ2DkGbyZ+1PLqbeiFczlQFDh9Weq7
	 S3x1BRZWYjav2pktIz0DqQYKYvNWfuZl3l5UDJHHc1FxBZpT4vdnMATaN5Pdqi6QOW
	 kLIL0Vz2L0ld4bwTC8Lkh1ogZzeMDOyPQacEg5ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Akshata MukundShetty <akshata.mukundshetty@amd.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.4 004/292] HID: amd_sfh: Rename the float32 variable
Date: Fri, 21 Jul 2023 18:01:53 +0200
Message-ID: <20230721160529.000192189@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

commit c1685a862a4bea863537f06abaa37a123aef493c upstream.

As float32 is also used in other places as a data type, it is necessary
to rename the float32 variable in order to avoid confusion.

Cc: stable@vger.kernel.org
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Akshata MukundShetty <akshata.mukundshetty@amd.com>
Link: https://lore.kernel.org/r/20230707065722.9036-2-Basavaraj.Natikar@amd.com
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_desc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_desc.c
+++ b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_desc.c
@@ -132,13 +132,13 @@ static void get_common_inputs(struct com
 	common->event_type = HID_USAGE_SENSOR_EVENT_DATA_UPDATED_ENUM;
 }
 
-static int float_to_int(u32 float32)
+static int float_to_int(u32 flt32_val)
 {
 	int fraction, shift, mantissa, sign, exp, zeropre;
 
-	mantissa = float32 & GENMASK(22, 0);
-	sign = (float32 & BIT(31)) ? -1 : 1;
-	exp = (float32 & ~BIT(31)) >> 23;
+	mantissa = flt32_val & GENMASK(22, 0);
+	sign = (flt32_val & BIT(31)) ? -1 : 1;
+	exp = (flt32_val & ~BIT(31)) >> 23;
 
 	if (!exp && !mantissa)
 		return 0;
@@ -151,10 +151,10 @@ static int float_to_int(u32 float32)
 	}
 
 	shift = 23 - exp;
-	float32 = BIT(exp) + (mantissa >> shift);
+	flt32_val = BIT(exp) + (mantissa >> shift);
 	fraction = mantissa & GENMASK(shift - 1, 0);
 
-	return (((fraction * 100) >> shift) >= 50) ? sign * (float32 + 1) : sign * float32;
+	return (((fraction * 100) >> shift) >= 50) ? sign * (flt32_val + 1) : sign * flt32_val;
 }
 
 static u8 get_input_rep(u8 current_index, int sensor_idx, int report_id,


