Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD781E47B4;
	Mon, 21 Oct 2024 10:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506743; cv=none; b=XJ/Y3ZXZ5sbI0qZayYmMvp5Msh3tWWxxQ22NnSpPKDzq1jntEwZ9Nhei/93Wf5Ud/EN9BWOLDr8ZCGw6/90BJae54tb+4lwZ6UUpcYkb6PjmO+X0goC+VZ0/Fx3pNLE8yNrCZ8xsxp9dxXOwFKHVXDInx3W2Ixm4eSP1RaivoOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506743; c=relaxed/simple;
	bh=Lqt9l6oBljZmpWtSg7yY9ip+a4GdOUqMcERdZHJw3b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSPyOlfyqxaebBWrMVi/aVqNdCIaQQwV3iBfRRM2Q2CjiPteEYZU2R12mw0KZYmhGbgOzVOldejHmSOQCGIfPUW/YiGg1ESDJl4Fam5RmT7NxxDOr9KM/PIdhc28oRfrBonDCmHSGLuaZpvhUsVbuLU1ZEnT82rgV/+iTRq7UKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OAVrH9w5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OAVrH9w5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6F2C4CEC3;
	Mon, 21 Oct 2024 10:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506743;
	bh=Lqt9l6oBljZmpWtSg7yY9ip+a4GdOUqMcERdZHJw3b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OAVrH9w58LzfVlnUZnp2PzSHfKFQVzf2nEfId0KsDLfHk8ecRp1agZJXT8xTTfqm4
	 Y4OhHcXlq+vSZG2lz70ZfTbyEq2X3cM0rQg9y6GOpAHzrtYQc/LJZp5m5/6oFGZKdF
	 sEEvOo64SBjl36vTDpqba2VS1nNidBWbEJNHzGIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 075/135] iio: light: veml6030: fix ALS sensor resolution
Date: Mon, 21 Oct 2024 12:23:51 +0200
Message-ID: <20241021102302.264235044@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit c9e9746f275c45108f2b0633a4855d65d9ae0736 upstream.

The driver still uses the sensor resolution provided in the datasheet
until Rev. 1.6, 28-Apr-2022, which was updated with Rev 1.7,
28-Nov-2023. The original ambient light resolution has been updated from
0.0036 lx/ct to 0.0042 lx/ct, which is the value that can be found in
the current device datasheet.

Update the default resolution for IT = 100 ms and GAIN = 1/8 from the
original 4608 mlux/cnt to the current value from the "Resolution and
maximum detection range" table (Application Note 84367, page 5), 5376
mlux/cnt.

Cc: <stable@vger.kernel.org>
Fixes: 7b779f573c48 ("iio: light: add driver for veml6030 ambient light sensor")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20240923-veml6035-v2-1-58c72a0df31c@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/veml6030.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/veml6030.c
+++ b/drivers/iio/light/veml6030.c
@@ -780,7 +780,7 @@ static int veml6030_hw_init(struct iio_d
 
 	/* Cache currently active measurement parameters */
 	data->cur_gain = 3;
-	data->cur_resolution = 4608;
+	data->cur_resolution = 5376;
 	data->cur_integration_time = 3;
 
 	return ret;


