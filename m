Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD704611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36274C4339B;
	Sun, 28 May 2023 19:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302531;
	bh=dxuvqh8S5yG7Mvr/xZ2n3VfoEwgvoJaH0M7S7QTabWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YFbF1gTtySguJ0hTg/BsnnVex/TE5qS/VGgQllMeb9dIzn5kW6XnDUDfYoNeveKcH
	 GkAQvkGVDew+2bdrNx+QKAS+cwE8oI+TDp9w+Uc0C7BuZiSXpRzq+vQNlQHUSdVztw
	 xPh10XZ2bJ8LEKttU4jhKL2ouTos2YTI3WkBXfas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.1 012/119] platform/x86: hp-wmi: Fix cast to smaller integer type warning
Date: Sun, 28 May 2023 20:10:12 +0100
Message-Id: <20230528190835.750155482@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

commit ce95010ef62d4bf470928969bafc9070ae98cbb1 upstream.

Fix the following compiler warning:

drivers/platform/x86/hp/hp-wmi.c:551:24: warning: cast to smaller integer
   type 'enum hp_wmi_radio' from 'void *' [-Wvoid-pointer-to-enum-cast]

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230123132824.660062-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp/hp-wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -552,7 +552,7 @@ static int __init hp_wmi_enable_hotkeys(
 
 static int hp_wmi_set_block(void *data, bool blocked)
 {
-	enum hp_wmi_radio r = (enum hp_wmi_radio) data;
+	enum hp_wmi_radio r = (long)data;
 	int query = BIT(r + 8) | ((!blocked) << r);
 	int ret;
 


