Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EB61FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADEB0C433C9;
	Tue,  1 Aug 2023 09:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883285;
	bh=RbuvKrTO/lvaDb9dGFSCkw2dQ23aIzios9ci2FOF2HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mq5Yq0zVkR2eQA65qT/MEO+WNJ5D/cL0FKRiEzkhwcEvtHuzhZ7w1QNtugNWcBPn
	 QrZlltlci9k0MnjZdmMvWncAhLiyfWODMn6BZGrCOl2sKmBYnXGA5XbzjFouXN5bJ8
	 qiyrrvXfeeCGElwSiOKQvMPfupkWALyzEGHP6HQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Savic <savicaleksa83@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.4 181/239] hwmon: (aquacomputer_d5next) Fix incorrect PWM value readout
Date: Tue,  1 Aug 2023 11:20:45 +0200
Message-ID: <20230801091932.190096545@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aleksa Savic <savicaleksa83@gmail.com>

commit a746b3689546da27125da9ccaea62b1dbaaf927c upstream.

Commit 662d20b3a5af ("hwmon: (aquacomputer_d5next) Add support for
temperature sensor offsets") changed aqc_get_ctrl_val() to return
the value through a parameter instead of through the return value,
but didn't fix up a case that relied on the old behavior. Fix it
to use the proper received value and not the return code.

Fixes: 662d20b3a5af ("hwmon: (aquacomputer_d5next) Add support for temperature sensor offsets")
Cc: stable@vger.kernel.org
Signed-off-by: Aleksa Savic <savicaleksa83@gmail.com>
Link: https://lore.kernel.org/r/20230714120712.16721-1-savicaleksa83@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/aquacomputer_d5next.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/aquacomputer_d5next.c
+++ b/drivers/hwmon/aquacomputer_d5next.c
@@ -969,7 +969,7 @@ static int aqc_read(struct device *dev,
 			if (ret < 0)
 				return ret;
 
-			*val = aqc_percent_to_pwm(ret);
+			*val = aqc_percent_to_pwm(*val);
 			break;
 		}
 		break;


