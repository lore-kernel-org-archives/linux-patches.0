Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE782343D84;
	Mon, 18 Aug 2025 14:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526493; cv=none; b=j7hYdcZWtiGVFGdhvh89TeOHHI15awJFSVHb6Omw2kNXsMjN/JtYqNjQyjKVv2bOcv71iNHx7lOntY4NcEDguMjgmPU5CHh5/0QPbybPxDbuaqcvulbHqMY/xbR1u5+teuj/UJw5U7QQgwMNM/I/OXvCHWUDU0YcO8qmUEKcWDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526493; c=relaxed/simple;
	bh=7XzDAedVRZEFFDLahg5xsdVpcfx6b3mCKBVf6ETSJwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XjdYn+1dI1chSaS4CsQJxLh6VWgV0UdYc/SdFLq+lbkOJsBt2tqUukraH4kA4NGBhF5XuK8cmz2lp+pfQ1e24aw5f3jXzRG3VzjaBUQP34LsldhSacQXVipj3LIq/CO02OL0CU+UDl1/forcQltTdYZfFqyx8hjmtIUErX6QJGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2FgOeRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2FgOeRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE9CC113D0;
	Mon, 18 Aug 2025 14:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526493;
	bh=7XzDAedVRZEFFDLahg5xsdVpcfx6b3mCKBVf6ETSJwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2FgOeRjNT+inA6WXi4+1+28H7lAtvQFcbHyPRR9Dq9avPI/YCckK8UXI1/AJ+mOt
	 b75FE7WjCVHecEQOMXj6vhrnfVFtAggdzqIjKiXhbdRVca8n4JVlMpSewmOECAAK/0
	 vRO3CNQrtPGItfh3re9zVT89Vhgv1tyJDoGfy0BI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Mugnier <benjamin.mugnier@foss.st.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.16 553/570] media: i2c: vd55g1: Fix return code in vd55g1_enable_streams error path
Date: Mon, 18 Aug 2025 14:49:00 +0200
Message-ID: <20250818124527.175916331@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Mugnier <benjamin.mugnier@foss.st.com>

commit 5931eed35cb632ff8b7e0b0cc91abc6014c64045 upstream.

Enable stream was returning success even if an error occurred, fix it by
modifying the err_rpm_put return value to -EINVAL.

Signed-off-by: Benjamin Mugnier <benjamin.mugnier@foss.st.com>
Fixes: e56616d7b23c ("media: i2c: Add driver for ST VD55G1 camera sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/vd55g1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/vd55g1.c
+++ b/drivers/media/i2c/vd55g1.c
@@ -1082,7 +1082,7 @@ static int vd55g1_enable_streams(struct
 
 err_rpm_put:
 	pm_runtime_put(sensor->dev);
-	return 0;
+	return -EINVAL;
 }
 
 static int vd55g1_disable_streams(struct v4l2_subdev *sd,


