Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6961515B0F0;
	Mon, 29 Jan 2024 17:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548085; cv=none; b=Uu+fiDvJNTtllqZc0MVQXSu0UU4g/LOi8y77SaGt118an+tKOvAiNu+xoyl+bIr69fyrLbPopFItX+BkYDSL0fgmbJpOPas2zxoIfZGPpfKvk5/x9FCTaaLflHgx4gy8+lnk45ZcairMSBswZiqe5d6ujlflMK+6wm5Zjn7aGzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548085; c=relaxed/simple;
	bh=VIf2A1pAPoqtg/jycnIEaclb+Kd60KNQXRFJe1yEsbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSCUfuzS4tBpEJedQzhRqV8ycOgnUKyfIbaF0as1TCETTUf/zsyw69cUYCy6CjihsMTQf6n2y5aOY+ZggY8llT7L9rGJfvGvQpfzB22Qt5RBFgw5mQUg/9QYQKN7SzUYoRXwXvp7OvwQ9c0QxiLpQmqukmyPVuYw07vxoFFPuY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E2Ode3LG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E2Ode3LG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D30C43390;
	Mon, 29 Jan 2024 17:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548085;
	bh=VIf2A1pAPoqtg/jycnIEaclb+Kd60KNQXRFJe1yEsbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E2Ode3LGc57Okg4qRGkns4A2dL2qfYDJe9pj7swD/cnyp6RvIh6Wp6bKwazRgCxoq
	 RdUeu/0dJXFBE9PF9FnXiXKdc3MACQO4Lpfs0zlZ8C70Toh+ZJcnBQyEv7WEUm6F/z
	 uIzyyMBfGx12Jfm27NlS6N9su+Maqh2MG6uOzLyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Volmat <alain.volmat@foss.st.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Benjamin Mugnier <benjamin.mugnier@foss.st.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.7 099/346] media: i2c: st-mipid02: correct format propagation
Date: Mon, 29 Jan 2024 09:02:10 -0800
Message-ID: <20240129170019.309310951@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alain Volmat <alain.volmat@foss.st.com>

commit b33cb0cbe2893b96ecbfa16254407153f4b55d16 upstream.

Use a copy of the struct v4l2_subdev_format when propagating
format from the sink to source pad in order to avoid impacting the
sink format returned to the application.

Thanks to Jacopo Mondi for pointing the issue.

Fixes: 6c01e6f3f27b ("media: st-mipid02: Propagate format from sink to source pad")
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Reviewed-by: Benjamin Mugnier <benjamin.mugnier@foss.st.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/st-mipid02.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/st-mipid02.c
+++ b/drivers/media/i2c/st-mipid02.c
@@ -770,6 +770,7 @@ static void mipid02_set_fmt_sink(struct
 				 struct v4l2_subdev_format *format)
 {
 	struct mipid02_dev *bridge = to_mipid02_dev(sd);
+	struct v4l2_subdev_format source_fmt;
 	struct v4l2_mbus_framefmt *fmt;
 
 	format->format.code = get_fmt_code(format->format.code);
@@ -781,8 +782,12 @@ static void mipid02_set_fmt_sink(struct
 
 	*fmt = format->format;
 
-	/* Propagate the format change to the source pad */
-	mipid02_set_fmt_source(sd, sd_state, format);
+	/*
+	 * Propagate the format change to the source pad, taking
+	 * care not to update the format pointer given back to user
+	 */
+	source_fmt = *format;
+	mipid02_set_fmt_source(sd, sd_state, &source_fmt);
 }
 
 static int mipid02_set_fmt(struct v4l2_subdev *sd,


