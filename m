Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFA42EE266;
	Tue, 17 Jun 2025 16:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178278; cv=none; b=Tk3RxTUdoUbFZHWspOLKGOhrG6jhepqmdLdBzkt6x9OQm3N3vjigJg7drArG4mPthkdHxwmYSiFYcbgAHoRvIuIy6t5luQjBBEpBjVO+ZLjih53PiQc6/d/zVgX+mZH4q+tWRL7xd6jGXmtF+EjOqVbn22uQ2/msxCQWTRkG8CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178278; c=relaxed/simple;
	bh=BC+M0KMmaZL4t3GVPsZOtZIP6JpL3GeT2kzPHrCzkV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwgxuhYLYMANGWWkInO0WU4s9AonvUS4UQbPpGONSw/fMXs/xYUdKICSwZPMaOxhz2wd5pX3vs4uvtO8HxIOyshW+Zz/+MxfneXiFx0WKyhMC3KiGpSjcfju1YoDaf24/ImPrryjL40/dkJ2XMHgkf/4+UPmKdSzaeOsXPE3aqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGlSGGX5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGlSGGX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A389C4CEE3;
	Tue, 17 Jun 2025 16:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178278;
	bh=BC+M0KMmaZL4t3GVPsZOtZIP6JpL3GeT2kzPHrCzkV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wGlSGGX54+1cLo/NB2UUPKDifURHarUOsE4KRpD3fHv7c1KIBIAnUZZbIMXIyj0uy
	 m3virRy9MCHE2eZn2txd/+ma/pgnLr28/q0EBM0h71YFflqVRbpRWo4jMh38Ws81hY
	 BidHfhDnDkYHZ4B1J/ctq/UAAn9LNQXAdKUNPWmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>,
	Even Xu <even.xu@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 429/780] HID: intel-thc-hid: intel-quicki2c: pass correct arguments to acpi_evaluate_object
Date: Tue, 17 Jun 2025 17:22:17 +0200
Message-ID: <20250617152508.937057103@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Guan <guanwentao@uniontech.com>

[ Upstream commit 37d66cf07871927ea682c491b9e9a12dd73e6b5b ]

Delete unused argument, pass correct argument to acpi_evaluate_object.

Log:
  intel_quicki2c 0000:00:10.0: enabling device (0000 -> 0002)
  ACPI: \_SB.PC00.THC0.ICRS: 1 arguments were passed to a non-method ACPI object (Buffer) (20230628/nsarguments-211)
  ACPI: \_SB.PC00.THC0.ISUB: 1 arguments were passed to a non-method ACPI object (Buffer) (20230628/nsarguments-211)

Fixes: 5282e45ccbfa ("HID: intel-thc-hid: intel-quicki2c: Add THC QuickI2C ACPI interfaces")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Reviewed-by: Even Xu <even.xu@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c b/drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c
index fa51155ebe393..8a8c4a46f9270 100644
--- a/drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c
+++ b/drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c
@@ -82,15 +82,10 @@ static int quicki2c_acpi_get_dsd_property(struct acpi_device *adev, acpi_string
 {
 	acpi_handle handle = acpi_device_handle(adev);
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
-	union acpi_object obj = { .type = type };
-	struct acpi_object_list arg_list = {
-		.count = 1,
-		.pointer = &obj,
-	};
 	union acpi_object *ret_obj;
 	acpi_status status;
 
-	status = acpi_evaluate_object(handle, dsd_method_name, &arg_list, &buffer);
+	status = acpi_evaluate_object(handle, dsd_method_name, NULL, &buffer);
 	if (ACPI_FAILURE(status)) {
 		acpi_handle_err(handle,
 				"Can't evaluate %s method: %d\n", dsd_method_name, status);
-- 
2.39.5



