Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AF2196D9C;
	Thu,  6 Jun 2024 14:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682926; cv=none; b=XQLsuWYJYPz1jcZrYSpr9SC5k6zZFTpe8+zndhW23bYZs0f2GWTnN5BLAaQNtJsfzsgz4XIPTChmd+eqU08xR5t4nAC1N7Lgyytu8b+gKjqX404+MgsXJfWR90cp5w6DpzIkNdO5ExzBmzeqqSKY/pzOh7lQQ0chOlR2KP77r9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682926; c=relaxed/simple;
	bh=unRsShBNe/N0U2GfSjd6mQYRIffBHoMtYWbOVSs7fgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjD2XxnfonpChebGGKLw7nYy4GUYWyT8KrlW0CWPOp7Iby6VUd3xm50Gi7dop7fAdECsCoUaVVG7LpFbTknhqE3zuVJK5zPmee1IS4AiPyDsURecf13E68qZEZHsj+oOoV868S3kNgg9XDY0Qz5gRwAXzViZD/phPSPB3+sXIpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZbdsgrb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZbdsgrb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9B1C32782;
	Thu,  6 Jun 2024 14:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682925;
	bh=unRsShBNe/N0U2GfSjd6mQYRIffBHoMtYWbOVSs7fgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZbdsgrbv9VWET1KFXCDCnxyKps94/pni7lUk7rrGq6j2svOitCoTRzaG/tbZkt5c
	 5YrUrMqBx9eCc97ihGmM0E7NCyAv90TbcpIOO1dUs5giRlsA97aU17d1x+EaURPf/k
	 bU72G+QkGfkD73SFMzkNo/ol01hiM4DCt3ChrV6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramona Gradinariu <ramona.gradinariu@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 069/374] docs: iio: adis16475: fix device files tables
Date: Thu,  6 Jun 2024 16:00:48 +0200
Message-ID: <20240606131654.143778374@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ramona Gradinariu <ramona.bolboaca13@gmail.com>

[ Upstream commit c19f273cae8ac785f83345f6eb2b2813d35ec148 ]

Remove in_accel_calibbias_x and in_anglvel_calibbias_x device files
description, as they do not exist and were added by mistake.
Add correct naming for in_accel_y_calibbias and in_anglvel_y_calibbias
device files and update their description.

Fixes: 8243b2877eef ("docs: iio: add documentation for adis16475 driver")
Signed-off-by: Ramona Gradinariu <ramona.gradinariu@analog.com>
Link: https://lore.kernel.org/r/20240424094152.103667-2-ramona.gradinariu@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/iio/adis16475.rst | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/Documentation/iio/adis16475.rst b/Documentation/iio/adis16475.rst
index 91cabb7d8d057..130f9e97cc17c 100644
--- a/Documentation/iio/adis16475.rst
+++ b/Documentation/iio/adis16475.rst
@@ -66,11 +66,9 @@ specific device folder path ``/sys/bus/iio/devices/iio:deviceX``.
 +-------------------------------------------+----------------------------------------------------------+
 | in_accel_x_calibbias                      | Calibration offset for the X-axis accelerometer channel. |
 +-------------------------------------------+----------------------------------------------------------+
-| in_accel_calibbias_x                      | x-axis acceleration offset correction                    |
-+-------------------------------------------+----------------------------------------------------------+
 | in_accel_x_raw                            | Raw X-axis accelerometer channel value.                  |
 +-------------------------------------------+----------------------------------------------------------+
-| in_accel_calibbias_y                      | y-axis acceleration offset correction                    |
+| in_accel_y_calibbias                      | Calibration offset for the Y-axis accelerometer channel. |
 +-------------------------------------------+----------------------------------------------------------+
 | in_accel_y_raw                            | Raw Y-axis accelerometer channel value.                  |
 +-------------------------------------------+----------------------------------------------------------+
@@ -94,11 +92,9 @@ specific device folder path ``/sys/bus/iio/devices/iio:deviceX``.
 +---------------------------------------+------------------------------------------------------+
 | in_anglvel_x_calibbias                | Calibration offset for the X-axis gyroscope channel. |
 +---------------------------------------+------------------------------------------------------+
-| in_anglvel_calibbias_x                | x-axis gyroscope offset correction                   |
-+---------------------------------------+------------------------------------------------------+
 | in_anglvel_x_raw                      | Raw X-axis gyroscope channel value.                  |
 +---------------------------------------+------------------------------------------------------+
-| in_anglvel_calibbias_y                | y-axis gyroscope offset correction                   |
+| in_anglvel_y_calibbias                | Calibration offset for the Y-axis gyroscope channel. |
 +---------------------------------------+------------------------------------------------------+
 | in_anglvel_y_raw                      | Raw Y-axis gyroscope channel value.                  |
 +---------------------------------------+------------------------------------------------------+
-- 
2.43.0



