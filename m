Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B8526B0A5;
	Thu, 13 Feb 2025 15:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459779; cv=none; b=JXuFYv7gW9o1VAjy6sW08Rt+pSDMh7nfnhRxZPvcE7H2vjmK2RPYd8DwKzazn11qGEBvmPccYQw/iF/sfhRrvOycL++vVFNJ34x3p3Huk+vgHh3RX11LFaULlJamhJBnFOsQ0BViD3zClv6JgjwTYdUXj6f6ieBbTqK+zn+mUVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459779; c=relaxed/simple;
	bh=hvL42GESQdgcX+IFGNtavTEAV6POsv+jvl1PKqX4uos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6JlNOS0ts3aKnYA2mzsM2hZPzv3DRttNpnU6lZb8IGYS4wh9zVHdM4BxPG8s5sDVqt40LmjFgE/EGi0BhVOO9/Eyukw18w8zihDOtHhYaIKUSIGb64HpWPkBcXvBqFTdxvk/AfCndBpHWw9cqEr6vIMK7keRuDF+jLR0y+Cr30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pe9zFV58; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pe9zFV58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F023C4CED1;
	Thu, 13 Feb 2025 15:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459779;
	bh=hvL42GESQdgcX+IFGNtavTEAV6POsv+jvl1PKqX4uos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pe9zFV58cVViMTcgeNlvOdTgNMEud4fXvLDLjNC9gKJ4IkPDTD5DJaM/KzGIXOZ83
	 SmL9/xjO4PFUKzejAG/DngxXDXUwIdXbvOXgRT2DJ4HjMrUltBzqcfR6XrEnyX6Kga
	 hA/wbhdRs9y9mbODRwFGQ+Z2emU/fg4PRgUkhyes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Bobrowicz <sam@elite-embedded.com>,
	Michal Simek <michal.simek@amd.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.13 362/443] media: ov5640: fix get_light_freq on auto
Date: Thu, 13 Feb 2025 15:28:47 +0100
Message-ID: <20250213142454.579951988@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Bobrowicz <sam@elite-embedded.com>

commit 001d3753538d26ddcbef011f5643cfff58a7f672 upstream.

Light frequency was not properly returned when in auto
mode and the detected frequency was 60Hz.

Fixes: 19a81c1426c1 ("[media] add Omnivision OV5640 sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sam Bobrowicz <sam@elite-embedded.com>
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov5640.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1982,6 +1982,7 @@ static int ov5640_get_light_freq(struct
 			light_freq = 50;
 		} else {
 			/* 60Hz */
+			light_freq = 60;
 		}
 	}
 


