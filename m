Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98BD1B4121;
	Mon, 23 Dec 2024 16:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970029; cv=none; b=Beo0DOLGH5vOeAtnN4E4jEykynF374A+xDJtFo4Wj0cK/zfAROuT6UTYxvO9qGvLI3/8mcLcDLil1urBL0oPPuQeq/VskUaPpEWSFoIK6xScUkj4qBaK4ZO5uCCCrlRXV6MAxEfEgD683jJSX3VOgrEEPeB7PGWR5sL9/fxvEZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970029; c=relaxed/simple;
	bh=rgX45OdS9AcwLF1WE9on6tBdQ/QkxP6T6U2XLcRm8io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQXLST1XCKU2xHMXfJ271PILGpJi+nNbesgFMUnNYHaJVl2OWIuikE6rhYgsMh+I7+tDJyBXJMdMAanIf9QT7rxmR3rO/jzq3HtPJRfJNGt7LJqfqrCCUUTdcPeKESMPYObB13RIro2f7TKFwEe+Yi/9E8ADBU6QTYlWyA9NBEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWtESyiF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWtESyiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AFDC4CED6;
	Mon, 23 Dec 2024 16:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970029;
	bh=rgX45OdS9AcwLF1WE9on6tBdQ/QkxP6T6U2XLcRm8io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hWtESyiFnPdhPcGOY5AlQLCMqR04Ex7cg9TTqs10Tgczf8rFAy2uPbfMUv29ocmHD
	 9Y7gl3jvGypnGb1vmaFLW3eTYM8oU2WxYiPi4v45sNFlOtuVinT7t7/GWaa955wQM7
	 BQxVTYWYybFViqqyi3wx89OyJr9IsGAe/qNzpU+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dexuan Cui <decui@microsoft.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 6.12 124/160] tools: hv: Fix a complier warning in the fcopy uio daemon
Date: Mon, 23 Dec 2024 16:58:55 +0100
Message-ID: <20241223155413.569153203@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dexuan Cui <decui@microsoft.com>

commit cb1b78f1c726c938bd47497c1ab16b01ce967f37 upstream.

hv_fcopy_uio_daemon.c:436:53: warning: '%s' directive output may be truncated
writing up to 14 bytes into a region of size 10 [-Wformat-truncation=]
  436 |  snprintf(uio_dev_path, sizeof(uio_dev_path), "/dev/%s", uio_name);

Also added 'static' for the array 'desc[]'.

Fixes: 82b0945ce2c2 ("tools: hv: Add new fcopy application based on uio driver")
Cc: stable@vger.kernel.org # 6.10+
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Link: https://lore.kernel.org/r/20240910004433.50254-1-decui@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20240910004433.50254-1-decui@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/hv/hv_fcopy_uio_daemon.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/hv/hv_fcopy_uio_daemon.c b/tools/hv/hv_fcopy_uio_daemon.c
index 7a00f3066a98..12743d7f164f 100644
--- a/tools/hv/hv_fcopy_uio_daemon.c
+++ b/tools/hv/hv_fcopy_uio_daemon.c
@@ -35,8 +35,6 @@
 #define WIN8_SRV_MINOR		1
 #define WIN8_SRV_VERSION	(WIN8_SRV_MAJOR << 16 | WIN8_SRV_MINOR)
 
-#define MAX_FOLDER_NAME		15
-#define MAX_PATH_LEN		15
 #define FCOPY_UIO		"/sys/bus/vmbus/devices/eb765408-105f-49b6-b4aa-c123b64d17d4/uio"
 
 #define FCOPY_VER_COUNT		1
@@ -51,7 +49,7 @@ static const int fw_versions[] = {
 
 #define HV_RING_SIZE		0x4000 /* 16KB ring buffer size */
 
-unsigned char desc[HV_RING_SIZE];
+static unsigned char desc[HV_RING_SIZE];
 
 static int target_fd;
 static char target_fname[PATH_MAX];
@@ -409,8 +407,8 @@ int main(int argc, char *argv[])
 	struct vmbus_br txbr, rxbr;
 	void *ring;
 	uint32_t len = HV_RING_SIZE;
-	char uio_name[MAX_FOLDER_NAME] = {0};
-	char uio_dev_path[MAX_PATH_LEN] = {0};
+	char uio_name[NAME_MAX] = {0};
+	char uio_dev_path[PATH_MAX] = {0};
 
 	static struct option long_options[] = {
 		{"help",	no_argument,	   0,  'h' },
-- 
2.47.1



