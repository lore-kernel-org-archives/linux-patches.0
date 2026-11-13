Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585913;
	b=u2II0WubFuyz2Vo6mYaaZ1iSmc8xC4VCj9ubiHAyzkDadN0cRvyA7RCUE3MxhGfrA11G
	 AMs7DGtD+TM8tQjDDXcE9neLJduT6V+2Em6LSE/g5y1qzEdZRQDZ0Zc3Swf4CgoSnsaRJ
	 1jQsQbM2UaQmEDUVJK4jJYEJhoZEiyYK1+C3NqtlFuGk2y46f34Q8jAAl1wtz29UxRxeg
	 7+n8IGGCk+b4pmezZSUJXnImQfmGcILbM7nZsmx7CbCysfwIzbA0CBQvUt30BkaeqYH4j
	 qsYI6aFyPBpaw36/QnGzj3sDOblMnynM961IlyMYqSCxMG0M3KcCYGCf5VNl0yKEM8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LvNGVpYQMe9vfmIrdP/QlVg1Z+TocDSA0E9qKsj7xLE=;
	b=nzYH/XMcRnKX/Y1B5ZZADcenIO3GGFudCnV3O1UQDfmlrkNpDbxYw7X7QpIveKTEBGCR
	 GXFDc753IHCg1MdaoVT3wO22Wu7xHqWPCvJpEUTfTPT1CuLZutG8AXJH3Q9h8SeGQLb3D
	 hKxlt244neSVj5+0wJXWDLJWSIInIVxvqZ1xU8NLOWLx0fIUlFwIsK3VcYVnkpIPx4bWH
	 IFq3LcKCpeyQatmTHQqYOro2J7oxpr7JLbmkGJdpd7sb6oGLn+3FZd0A9/yxN6HcWA73X
	 clc8wOYrMS88mOy8/D6DHtP/G7f7Lqzh7AeB761idl6DkGiSHCUonMMKpJSqnnyGyHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lVNZv1K8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD8B6076E17;
	Fri, 13 Nov 2026 16:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lVNZv1K8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7921F000C7;
	Fri, 13 Nov 2026 16:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585913;
	bh=LvNGVpYQMe9vfmIrdP/QlVg1Z+TocDSA0E9qKsj7xLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lVNZv1K84QCLhO4TnzPHNJqYwCVxCehOMYa1XlLqTHgacZQqnfAA2THWYnBc8jtff
	 WXKeoOpTqcUBoIH4z6+/FdrGRj9I/1yFp32x+fqSbO4JY0e0kuVRrIqU55NLkWbhGD
	 aLiCGlJErhCan1smIOX9j3w0U1rOoeZQHVmXjp8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hemanth Selam <hemanth.selam@gmail.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 459/507] platform/chrome: Fix typos in comments
Date: Fri, 13 Nov 2026 10:52:43 -0500
Message-ID: <20261113153812.269476525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hemanth Selam <hemanth.selam@gmail.com>

[ Upstream commit 2d23d5e9cb468baf6e4fa78d0dd7e8555759385d ]

Fix typos in comments, reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
Link: https://lore.kernel.org/r/20260904110900.20435-2-hemanth.selam@gmail.com
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Stable-dep-of: ca75b38b1a3c ("platform/chrome: cros_usbpd_notify: Only use drvdata when parent is GOOG0004")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_ishtp.c     | 2 +-
 drivers/platform/chrome/cros_usbpd_notify.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_ishtp.c b/drivers/platform/chrome/cros_ec_ishtp.c
index 3766cef81fe82..b21a27ad37625 100644
--- a/drivers/platform/chrome/cros_ec_ishtp.c
+++ b/drivers/platform/chrome/cros_ec_ishtp.c
@@ -369,7 +369,7 @@ static void ish_event_cb(struct ishtp_cl_device *cl_device)
  * @cros_ish_cl: ISHTP client instance
  * @reset: true if called from reset handler
  *
- * This function complete the initializtion of the client.
+ * This function complete the initialization of the client.
  *
  * Return: 0 for success, negative error code for failure.
  */
diff --git a/drivers/platform/chrome/cros_usbpd_notify.c b/drivers/platform/chrome/cros_usbpd_notify.c
index d842c05f4db00..6f5eea4938cb4 100644
--- a/drivers/platform/chrome/cros_usbpd_notify.c
+++ b/drivers/platform/chrome/cros_usbpd_notify.c
@@ -64,7 +64,7 @@ static void cros_usbpd_get_event_and_notify(struct device  *dev,
 
 	/*
 	 * We still send a 0 event out to older devices which don't
-	 * have the updated device heirarchy.
+	 * have the updated device hierarchy.
 	 */
 	if (!ec_dev) {
 		dev_dbg(dev,
@@ -115,7 +115,7 @@ static int cros_usbpd_notify_probe_acpi(struct platform_device *pdev)
 	if (!ec_dev) {
 		/*
 		 * We continue even for older devices which don't have the
-		 * correct device heirarchy, namely, GOOG0003 is a child
+		 * correct device hierarchy, namely, GOOG0003 is a child
 		 * of GOOG0004. If GOOG0003 is a child of GOOG0004 and we
 		 * can't get a pointer to the Chrome EC device, defer the
 		 * probe function.
-- 
2.53.0



