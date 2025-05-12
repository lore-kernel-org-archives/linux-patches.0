Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19896140E34;
	Mon, 12 May 2025 18:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072945; cv=none; b=aWsmtNp5EDpjemNjjRWRQp+gpn6GPG6q1a8LUwXFDcfPPGXRo4YbcBFLf/icKq/nqpfqBRNz0258O16rJTy6/UIudz27wf70UBb8Til+Bn0pIer8fj4i/nc/MKAlqSMHi0z5kNNoXGUbnVEIAHSMEb1aqNzcwgi6bqN80OkldtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072945; c=relaxed/simple;
	bh=Mlg+utnbrLdqodzd+hazk1IxMoIhMcg2OLD0EiECYP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYvRntgO6stmL5bVTreNaX35KfiYqL1+50XMpmAUPZNOuRAOk7KmVBBHgL5zFx0CXjGJmBLrlM5sHJTQ+npAOkrp9rO3AYyO8SVSUlSr7D4xw8i8XWizENjBbGJnjND+dtFv907pn8LksTeEfaQ0aoHRuTRsIoTjvx9jMf8ftZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8q8N1jW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8q8N1jW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA24C4CEE7;
	Mon, 12 May 2025 18:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072945;
	bh=Mlg+utnbrLdqodzd+hazk1IxMoIhMcg2OLD0EiECYP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y8q8N1jWF8YUae6NOooH+Mwn13HffErJj0yuUwkpXvvvun3QwJd+d/LAGQst7Mba/
	 g9a/kvpuFHMfXTi2olY15TeaLvYA/td/TdClA/ork5RCN6JoJWFVZzLIY65ERNYTGD
	 NyCdfyEMK2nuFxgaRSXCCN5amiCP46rHw4YiqUMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.12 106/184] accel/ivpu: Increase state dump msg timeout
Date: Mon, 12 May 2025 19:45:07 +0200
Message-ID: <20250512172046.137789102@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

commit c4eb2f88d2796ab90c5430e11c48709716181364 upstream.

Increase JMS message state dump command timeout to 100 ms. On some
platforms, the FW may take a bit longer than 50 ms to dump its state
to the log buffer and we don't want to miss any debug info during TDR.

Fixes: 5e162f872d7a ("accel/ivpu: Add FW state dump on TDR")
Cc: stable@vger.kernel.org # v6.13+
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://lore.kernel.org/r/20250425092822.2194465-1-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/accel/ivpu/ivpu_hw.c
+++ b/drivers/accel/ivpu/ivpu_hw.c
@@ -106,7 +106,7 @@ static void timeouts_init(struct ivpu_de
 		else
 			vdev->timeout.autosuspend = 100;
 		vdev->timeout.d0i3_entry_msg = 5;
-		vdev->timeout.state_dump_msg = 10;
+		vdev->timeout.state_dump_msg = 100;
 	}
 }
 


