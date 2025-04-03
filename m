Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F873194A59;
	Thu,  3 Apr 2025 06:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743662985; cv=none; b=XMRoksfGDlDic6P3RWctv6vroHfe8UArRGh7gvpd5U0TbH9YS6S33dk58s2KujIxBwguiEhzKFwnmyULThbGYM0NrcRcu6IVPkz7CNWM2tHoS+6L/Q73nHKoGxdXDh2mXzT+KPF6Iw5mEdiAXhWtvijVM/Uv+Irn5I0OU5qIT48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743662985; c=relaxed/simple;
	bh=vgDK6hP6Qs5vLrru7PJGnb/Mqd8iT5lCj+6AGozYMU8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YLkh6wO+1TgMzdN/OZS3naoqrjgR1Lfi49ssJksp5ns8LkUhwLUkXq33hdEiyC6YY+oO7nLteUhp5Fxw+f8xhEoChV4unr1GzarA3Cjlpjs5Qb7pyzNXqW96wYoAgw+RJ6nHPG5IG1S3WfJi8x8WcF11Qs2/eEGMkxfRkOyT3Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5334o2rd010959;
	Thu, 3 Apr 2025 06:49:39 GMT
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 45sg0q8b10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 03 Apr 2025 06:49:39 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Wed, 2 Apr 2025 23:49:38 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Wed, 2 Apr 2025 23:49:35 -0700
From: <jianqi.ren.cn@windriver.com>
To: <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <jianqi.ren.cn@windriver.com>,
        <laurent.pinchart@ideasonboard.com>, <dan.scally@ideasonboard.com>,
        <linux-usb@vger.kernel.org>, <abhishektamboli9@gmail.com>
Subject: [PATCH 6.6.y] usb: gadget: uvc: Fix ERR_PTR dereference in uvc_v4l2.c
Date: Thu, 3 Apr 2025 14:49:35 +0800
Message-ID: <20250403064935.51299-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: Rwu53oHxXM2sWj_BOR1z2ne_zHhppLce
X-Proofpoint-ORIG-GUID: Rwu53oHxXM2sWj_BOR1z2ne_zHhppLce
X-Authority-Analysis: v=2.4 cv=G+4cE8k5 c=1 sm=1 tr=0 ts=67ee2f83 cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=XR8D0OoHHMoA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=ag1SF4gXAAAA:8 a=t7CeM3EgAAAA:8 a=REYqGfaRdox0a-FwMx0A:9
 a=Yupwre4RP9_Eg_Bd0iYG:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-03_02,2025-04-02_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 clxscore=1011 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.21.0-2502280000
 definitions=main-2504030033

From: Abhishek Tamboli <abhishektamboli9@gmail.com>

[ Upstream commit a7bb96b18864225a694e3887ac2733159489e4b0 ]

Fix potential dereferencing of ERR_PTR() in find_format_by_pix()
and uvc_v4l2_enum_format().

Fix the following smatch errors:

drivers/usb/gadget/function/uvc_v4l2.c:124 find_format_by_pix()
error: 'fmtdesc' dereferencing possible ERR_PTR()

drivers/usb/gadget/function/uvc_v4l2.c:392 uvc_v4l2_enum_format()
error: 'fmtdesc' dereferencing possible ERR_PTR()

Also, fix similar issue in uvc_v4l2_try_format() for potential
dereferencing of ERR_PTR().

Signed-off-by: Abhishek Tamboli <abhishektamboli9@gmail.com>
Link: https://lore.kernel.org/r/20240815102202.594812-1-abhishektamboli9@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
Verified the build test
---
 drivers/usb/gadget/function/uvc_v4l2.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/uvc_v4l2.c b/drivers/usb/gadget/function/uvc_v4l2.c
index 3f0a9795c0d4..0195625bef53 100644
--- a/drivers/usb/gadget/function/uvc_v4l2.c
+++ b/drivers/usb/gadget/function/uvc_v4l2.c
@@ -121,6 +121,9 @@ static struct uvcg_format *find_format_by_pix(struct uvc_device *uvc,
 	list_for_each_entry(format, &uvc->header->formats, entry) {
 		const struct uvc_format_desc *fmtdesc = to_uvc_format(format->fmt);
 
+		if (IS_ERR(fmtdesc))
+			continue;
+
 		if (fmtdesc->fcc == pixelformat) {
 			uformat = format->fmt;
 			break;
@@ -240,6 +243,7 @@ uvc_v4l2_try_format(struct file *file, void *fh, struct v4l2_format *fmt)
 	struct uvc_video *video = &uvc->video;
 	struct uvcg_format *uformat;
 	struct uvcg_frame *uframe;
+	const struct uvc_format_desc *fmtdesc;
 	u8 *fcc;
 
 	if (fmt->type != video->queue.queue.type)
@@ -265,7 +269,10 @@ uvc_v4l2_try_format(struct file *file, void *fh, struct v4l2_format *fmt)
 	fmt->fmt.pix.field = V4L2_FIELD_NONE;
 	fmt->fmt.pix.bytesperline = uvc_v4l2_get_bytesperline(uformat, uframe);
 	fmt->fmt.pix.sizeimage = uvc_get_frame_size(uformat, uframe);
-	fmt->fmt.pix.pixelformat = to_uvc_format(uformat)->fcc;
+	fmtdesc = to_uvc_format(uformat);
+	if (IS_ERR(fmtdesc))
+		return PTR_ERR(fmtdesc);
+	fmt->fmt.pix.pixelformat = fmtdesc->fcc;
 	fmt->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
 	fmt->fmt.pix.priv = 0;
 
@@ -375,6 +382,9 @@ uvc_v4l2_enum_format(struct file *file, void *fh, struct v4l2_fmtdesc *f)
 		return -EINVAL;
 
 	fmtdesc = to_uvc_format(uformat);
+	if (IS_ERR(fmtdesc))
+		return PTR_ERR(fmtdesc);
+
 	f->pixelformat = fmtdesc->fcc;
 
 	return 0;
-- 
2.34.1

