Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B356E24677F;
	Thu, 28 May 2026 20:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998474; cv=none; b=pnmPl5YngBwN3S2ZkpENyPC0G9pEMMrxzlqmyFizA9ttHVeeThXHPthxkCIsPahYf6mQX7hQYIwYHTtRvXrxpSN4vxaq3tGPpfJ/8sXIoctkSDb8NV4Q0DMLPj7R5ajyvLsdZaAkLNjZYcW6KSA7JqFPVFKxVx/u0GZX4FnXQac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998474; c=relaxed/simple;
	bh=E/HlvaIGAWza6MHXMrRASu+TheEm62LcH1h7RVo2vdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLjybiascjtvUdrfWAZl4nqkesNO50pc9PtAhRIpntWa/YfgKuKRB0Oi8Y3H2YDTXnjUp8VBw9zoYj3xEsri2T+B4N2uTiF4aGU95vsUM4VpLOYeVxAYEIBtyxoMoP8DthOxZFYBol2ZdxMRsJ8Pwn/+8UKX6quM5gVrVYnRNGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OBZBsP7l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OBZBsP7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDC41F000E9;
	Thu, 28 May 2026 20:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998473;
	bh=Bx/A7fkCWshjSolDYOA0y8D++pmU1IBnuK7tcsBEMNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OBZBsP7lIwzfpIhSFam0UNoChm3PHysOeyGUlWlq+U/ae1xxailrkbVXJXQgUz/q5
	 oek/fVyP8wr2CN+RQhM9yK75e31Ann2gWIr3RvMxD1YhmwEzwh0OT1vV/gz37vvNoj
	 dO+NQOvloP1OynPIhl0v7h9o+YeR9xjynafGOYV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Even Xu <even.xu@intel.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 185/461] HID: intel-thc-hid: Intel-quickspi: Fix some error codes
Date: Thu, 28 May 2026 21:45:14 +0200
Message-ID: <20260528194652.431028075@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit ae4ac077332ea3341a0f4c0973556c6b7ac5b7a1 ]

If we have a partial read that is supposed to be treated as failure but
in this code we forgot to set the error code.  Return -EINVAL.

Fixes: 9d8d51735a3a ("HID: intel-thc-hid: intel-quickspi: Add HIDSPI protocol implementation")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Even Xu <even.xu@intel.com>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-thc-hid/intel-quickspi/quickspi-protocol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-protocol.c b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-protocol.c
index 16f780bc879b1..cb19057f1191b 100644
--- a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-protocol.c
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-protocol.c
@@ -94,7 +94,7 @@ static int quickspi_get_device_descriptor(struct quickspi_device *qsdev)
 		dev_err_once(qsdev->dev, "Read DEVICE_DESCRIPTOR failed, ret = %d\n", ret);
 		dev_err_once(qsdev->dev, "DEVICE_DESCRIPTOR expected len = %u, actual read = %u\n",
 			     input_len, read_len);
-		return ret;
+		return ret ?: -EINVAL;
 	}
 
 	input_rep_type = ((struct input_report_body_header *)read_buf)->input_report_type;
@@ -318,7 +318,7 @@ int reset_tic(struct quickspi_device *qsdev)
 		dev_err_once(qsdev->dev, "Read RESET_RESPONSE body failed, ret = %d\n", ret);
 		dev_err_once(qsdev->dev, "RESET_RESPONSE body expected len = %u, actual = %u\n",
 			     read_len, actual_read_len);
-		return ret;
+		return ret ?: -EINVAL;
 	}
 
 	input_rep_type = FIELD_GET(HIDSPI_IN_REP_BDY_HDR_REP_TYPE, reset_response);
-- 
2.53.0



