Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC5F1C32FF;
	Mon, 12 May 2025 17:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072052; cv=none; b=NdR7U2FJzGV8wx4Vo02YhKDs2yRb8XYLpT53CIiTYFPOzx/2lu4TlLtZmBGUdsL6525qhVVIkoZUrVMJKoUPsd9hDScnRQQaK+qDtPV5McL0dk/Sl2ED9jDhT58wNF3WK3Hsj1aMILMsdlfuBGdu4t9oydmtOGthm+LEhT1JXqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072052; c=relaxed/simple;
	bh=5QcsAKczmEuJ+sq0hsHKHSOadU4NRO1zOMozSNt70xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OiI70FMMjVF/2QQbwl8bq0M++j8lPCc72kFEfgPaXidxlHqVRe35mjljzntP4uf9A5kx1eitad+Fe671CcuMowluDOejY1r8sxXx0nY4BqY13THm4pgqFyga/mOKGaX6fsvXXNzF12GWvYUUrt+6otdwyerl6Wa+vRrcElh91MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/1AbAAH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/1AbAAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7755C4CEE7;
	Mon, 12 May 2025 17:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072052;
	bh=5QcsAKczmEuJ+sq0hsHKHSOadU4NRO1zOMozSNt70xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/1AbAAHxEXglc3/WqRrgdmrJMIbhPpxOBCw/TvyplOCwsO15jUkIHbaB8K1zaCrZ
	 CRdhdDy6xUxaIAOc6Ix2r9/V0QFyluuyj0NyLQLT6nEphYHJdLRUmc7ylUCN7/wRvL
	 eZvprr3Sff3zuYy+8aQYhOmqt4+gBiGQ7NMG7GhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.14 122/197] accel/ivpu: Increase state dump msg timeout
Date: Mon, 12 May 2025 19:39:32 +0200
Message-ID: <20250512172049.352299445@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
 


