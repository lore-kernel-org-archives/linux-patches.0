Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423AD1F955
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC41C433B9;
	Tue,  1 Aug 2023 09:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882199;
	bh=xa210WyPwxKWiyvN6sIxjtQJaL0inWUD2OC29I9DK1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QRHvZvCGB3zu40Eos5qiQazYpilMqPqBs4aPAUMxaW2b/D6gNz/4SuV7rS3GU3nxJ
	 T97eJrpxB+cZFuOEg0244FSJoi7xsIpb1tQghCajAfUlrGNdRXTOuYEnAsxlPvAeHW
	 epS70iCx+ZRaf1SCbohl2vTiinG44+4rH7iV9TA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.1 004/228] platform/x86/amd/pmf: reduce verbosity of apmf_get_system_params
Date: Tue,  1 Aug 2023 11:17:42 +0200
Message-ID: <20230801091922.980886094@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

commit 839e90e75e695b3d9ee17f5a2811e7ee5aea8d4a upstream.

apmf_get_system_params() failure is not a critical event, reduce its
verbosity from dev_err to dev_dbg.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://lore.kernel.org/r/20230714144435.1239776-1-Shyam-sundar.S-k@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmf/acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/amd/pmf/acpi.c
+++ b/drivers/platform/x86/amd/pmf/acpi.c
@@ -310,7 +310,7 @@ int apmf_acpi_init(struct amd_pmf_dev *p
 
 	ret = apmf_get_system_params(pmf_dev);
 	if (ret) {
-		dev_err(pmf_dev->dev, "APMF apmf_get_system_params failed :%d\n", ret);
+		dev_dbg(pmf_dev->dev, "APMF apmf_get_system_params failed :%d\n", ret);
 		goto out;
 	}
 


