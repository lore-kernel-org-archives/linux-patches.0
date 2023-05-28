Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECDA611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9065C433D2;
	Sun, 28 May 2023 19:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303163;
	bh=ZqyVq2uW/kSrPMC4BtPXLRw0hV6mV0rZZxbtcqzvR0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/OC6sJvJPc8PNgUSK1xv1Qp9P8cdQsp/mP+kYOxuQXYcfzLm5TTWtJ0PfRolEGqm
	 llz2qGUS3lmVC0qYROiBvw3Qm5hOtAJLM63ThlmV3vT5iosK3H8npPEl8FBMauxGY3
	 ynm8YucP1HtPii8QZKujAHJgyfO1KlMRbv+h22nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.10 152/211] HID: wacom: add three styli to wacom_intuos_get_tool_type
Date: Sun, 28 May 2023 20:11:13 +0100
Message-Id: <20230528190847.288721100@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ping Cheng <pinglinux@gmail.com>

commit bfdc750c4cb2f3461b9b00a2755e2145ac195c9a upstream.

We forgot to add the 3D pen ID a year ago. There are two new pro pen
IDs to be added.

Signed-off-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -713,11 +713,14 @@ static int wacom_intuos_get_tool_type(in
 	case 0x802: /* Intuos4/5 13HD/24HD General Pen */
 	case 0x8e2: /* IntuosHT2 pen */
 	case 0x022:
+	case 0x200: /* Pro Pen 3 */
+	case 0x04200: /* Pro Pen 3 */
 	case 0x10842: /* MobileStudio Pro Pro Pen slim */
 	case 0x14802: /* Intuos4/5 13HD/24HD Classic Pen */
 	case 0x16802: /* Cintiq 13HD Pro Pen */
 	case 0x18802: /* DTH2242 Pen */
 	case 0x10802: /* Intuos4/5 13HD/24HD General Pen */
+	case 0x80842: /* Intuos Pro and Cintiq Pro 3D Pen */
 		tool_type = BTN_TOOL_PEN;
 		break;
 


