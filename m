Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05028438029;
	Mon, 31 Aug 2026 13:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184566; cv=none; b=EfNKuAkDmCoVBhQkC886NVSdBbPvuSYURnPS51ie/2eey+H4HXyyEuu78MkfL8x2rVAxhBb91eKe8B8TrrAMovzqnVG8xwkmw6ehxv4jePf02ouLBlXvF262OCTLad3fHh2cOI/xBKG1rTvWIq37p/OchHV6wsv3XA3wk5fDdU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184566; c=relaxed/simple;
	bh=7bPndxmn2c4l8Ipr9eTPjJBBr+Qra3K23eW2LUgaPR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KvwIBVGQhC7bC6OImhaVcataE6fH+EzJ/LHcBxxcVSg4tnUGLjnF/yVedbtGt491uVhiMENF3HPnh70l7FdzUtHq63QluBPPkstPfcu5WXeQ37Q5DsrfGPB7+RRIJGgRJbhe7gebs1MBMKMU98+6OUJHixb2KpfsgRUkRyUE5q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=irPqOSiF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="irPqOSiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637641F00A3D;
	Mon, 31 Aug 2026 13:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184564;
	bh=IVcs7sAL21mW31CDUCurCfEbgWgCf2EcDaw3wokr6IY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=irPqOSiF0QzJ6gAhZR3nsHHh/p9iyPjhPDO6oYdTCChWSgDB47z0M9jVo5A7nP5MA
	 ex0PF3JEaj5n1bSYOfpBCTnwQb54IR5NYAWvgDA+x7pFq1pksNXANaoao4ugxb3RcS
	 t8rZO71YBBtkJmX0iJno9pwWGT1ua2zDAiblq+J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 52/91] HID: pidff: clang-format pass
Date: Mon, 31 Aug 2026 15:34:40 +0200
Message-ID: <20260831133402.448487401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit ae42428fb4e3d2eed344f0d6fcfa778bc8b8f80a ]

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 67bb1074e3d2 ("HID: pidff: fix OOB write when hid->inputs is empty")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/usbhid/hid-pidff.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -1298,8 +1298,8 @@ static int pidff_check_autocenter(struct
 int hid_pidff_init_with_quirks(struct hid_device *hid, __u32 initial_quirks)
 {
 	struct pidff_device *pidff;
-	struct hid_input *hidinput = list_entry(hid->inputs.next,
-						struct hid_input, list);
+	struct hid_input *hidinput =
+		list_entry(hid->inputs.next, struct hid_input, list);
 	struct input_dev *dev = hidinput->input;
 	struct ff_device *ff;
 	int max_effects;


