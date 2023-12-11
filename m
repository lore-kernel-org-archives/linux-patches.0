Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E5EFBE1;
	Mon, 11 Dec 2023 18:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1YFFn5iA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4D9C433C7;
	Mon, 11 Dec 2023 18:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320088;
	bh=IwmTUxTWWReX6Xh2eQ7RcejRfEmO6wy4pb4rgIgX/m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1YFFn5iAk5eBEwYcvYcCp6T2U8MmqQoQK70Z9rV27YZ7KmO7d9IDgc0QOqFG5v7id
	 DzRjAVp6SNTQ4wOgAV3cMmed7Bb6nE7jyFqNbstxllCiAQQZkX7IzKEq8IQU1oPe3v
	 VpSFd58XGjzZgFCGKjcVR2Yx3N2H0LSreLgTvtrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.10 90/97] platform/x86: asus-wmi: Document the dgpu_disable sysfs attribute
Date: Mon, 11 Dec 2023 19:22:33 +0100
Message-ID: <20231211182023.686873717@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182019.802717483@linuxfoundation.org>
References: <20231211182019.802717483@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luke D. Jones <luke@ljones.dev>

commit 7e64c486e807c8edfbd3a0c8e44ad7a1896dbec8 upstream.

The dgpu_disable attribute was not documented, this adds the
required documentation.

Fixes: 98829e84dc67 ("asus-wmi: Add dgpu disable method")
Signed-off-by: Luke D. Jones <luke@ljones.dev>
Link: https://lore.kernel.org/r/20220812222509.292692-2-luke@ljones.dev
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-platform-asus-wmi |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/Documentation/ABI/testing/sysfs-platform-asus-wmi
+++ b/Documentation/ABI/testing/sysfs-platform-asus-wmi
@@ -57,3 +57,12 @@ Description:
 			* 0 - default,
 			* 1 - overboost,
 			* 2 - silent
+
+What:		/sys/devices/platform/<platform>/dgpu_disable
+Date:		Aug 2022
+KernelVersion:	5.17
+Contact:	"Luke Jones" <luke@ljones.dev>
+Description:
+		Disable discrete GPU:
+			* 0 - Enable dGPU,
+			* 1 - Disable dGPU


