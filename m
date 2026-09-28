Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F8A36AB54
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 04:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790570979; cv=none; b=J7J6eFZWj9bZU8d1wVX6n+bNRODfphwY3GATHTBTUWMXjZFht9ZS2FYQtt6SjA21DZudpXK+VYEWtqD71RwR2QXsMOXNrIkPaMO8BxX14vG6d+12R7VKe66osqno9S920ygH72bdX6N/O66Qlpqw6nflx3vzcCYUBOLH4S8fJo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790570979; c=relaxed/simple;
	bh=QGDJOLvAfspgjbhM3t4N/oMkd5/ABeW0SYZDQhOHVII=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q5ZObQ3DgIrWOLVGp1Dj/ixzqogQNFPS0of45Ui5fe7F3oYdrRiKpzOjX+GGGPp5vY2XHQ0NuEUe0gDknPrYJq0m4D3q3Y/w0zXzAPM2Uo2OTVzIrQJv/O2isp2JJdABfqVmnygEb/2YgLl1iUrhHmCUkF+hqhZomjZAIUIo0HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.pku.edu.cn; spf=pass smtp.mailfrom=stu.pku.edu.cn; dkim=pass (1024-bit key) header.d=stu.pku.edu.cn header.i=@stu.pku.edu.cn header.b=TM9lrKa5; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=stu.pku.edu.cn header.i=@stu.pku.edu.cn header.b="TM9lrKa5"
Received: from SEWP216MB977011.KORP216.PROD.OUTLOOK.COM (unknown [IPV6:2603:1046:c07:1031:365:be:0:1b])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4f4ad2352;
	Mon, 28 Sep 2026 12:49:25 +0800 (GMT+08:00)
From: "springbreeze@stu.pku.edu.cn" <springbreeze@stu.pku.edu.cn>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, FUJITA Tomonori
	<fujita.tomonori@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 6.18 210/398] rust: net: phy: fix off-by-one bit positions
 in device status accessors
Thread-Topic: [PATCH 6.18 210/398] rust: net: phy: fix off-by-one bit
 positions in device status accessors
Thread-Index: ATA1NDYz975N8dx4L1GUKeoIbrHRRDI5ODYz2KHU030=
X-MS-Exchange-MessageSentRepresentingType: 1
Date: Mon, 28 Sep 2026 04:41:23 +0000
Message-ID:
	<SEWP216MB9770116738884C46F156A686FAF98D2@SEWP216MB977011.KORP216.PROD.OUTLOOK.COM>
References: <20260923140643.441954610@linuxfoundation.org>
 <20260923140648.864493062@linuxfoundation.org>
In-Reply-To: <20260923140648.864493062@linuxfoundation.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-Exchange-Organization-SCL: -1
X-MS-TNEF-Correlator:
X-MS-Exchange-Organization-RecordReviewCfmType: 0
msip_labels:
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-HM-Tid: 0aa0e658ab3603a1kunmf34da85d1e2d5e
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCT0tLVk5OGElKGU8fGE8aQlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJTUtIQUpLT01BGEtMQUpLSEpBSE1OQRkeQUtBShlZV1kWGg
	8SFR0UWUFZT0tIVUpLSUJDQ0xVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=TM9lrKa5u1C+f+QbrubijWiDan9vMZUMnZFpTfhiDhuTicx3w+f5X5Nom51pQW16he6NkWOz4L0C3rUHUJLFxappbUeCDc0yYo5E7yShxCNyhVKlJpYNE/vQwa0qvvpBs/fQgfJwPNiTd4826XBwgUzNMgQC8EC7a8rpHQ92Gf0=; c=relaxed/relaxed; s=default; d=stu.pku.edu.cn; v=1;
	bh=WqoXHxpmhcEcB9mb0N88gq9uzq/gBNvVqzcJjupMqeU=;
	h=date:mime-version:subject:message-id:from;

Hi Greg, Sasha,=0A=
=0A=
Please drop the 6.18.y patch as it stands in this review series, or take th=
e=0A=
variant below instead.=0A=
=0A=
The queued patch fixes the three accessors with the bindgen-generated raw=
=0A=
accessors (link_raw(), autoneg_raw(), autoneg_complete_raw()), which bindge=
n=0A=
only emits from 0.71 on.  This branch's documented minimum is 0.65.1=0A=
(scripts/min-tool-version.sh), so the patch applies cleanly but does not=0A=
build with the minimum supported toolchain.=0A=
=0A=
The bug itself is present here: 2796ff1e3dca shifted autoneg, link and=0A=
autoneg_complete up by one bit, and the hand-written offsets were never=0A=
updated.  It can be fixed without the raw accessors by correcting the=0A=
numbers directly:=0A=
=0A=
  is_link_up()            15 (was 14)=0A=
  is_autoneg_enabled()    14 (was 13)=0A=
  is_autoneg_completed()  16 (was 15)=0A=
=0A=
I re-checked the backport against v6.18 (rust/kernel/net/phy.rs blob=0A=
bf6272d87a7b); the corrected 6.18.y form is below.=0A=
=0A=
Thanks,=0A=
Chunfeng Song=0A=
=0A=
=0A=
________________________________________=0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>=0A=
Sent: Wednesday, September 23, 2026 22:04=0A=
To: stable@vger.kernel.org <stable@vger.kernel.org>=0A=
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; patches@lists.linux.de=
v <patches@lists.linux.dev>; Chunfeng Song <springbreeze@stu.pku.edu.cn>; F=
UJITA Tomonori <fujita.tomonori@gmail.com>; Jakub Kicinski <kuba@kernel.org=
>=0A=
Subject: [PATCH 6.18 210/398] rust: net: phy: fix off-by-one bit positions =
in device status accessors=0A=
=0A=
=0A=
6.18-stable review patch.=A0 If anyone has any objections, please let me kn=
ow.=0A=
=0A=
------------------=0A=
=0A=
From: Chunfeng Song <springbreeze@stu.pku.edu.cn>=0A=
=0A=
commit 6fb0a9d9071f1ff0cc5cfc0782302d9c90d642cb upstream.=0A=
=0A=
The hand-written bitfield offsets in is_link_up(), is_autoneg_enabled()=0A=
and is_autoneg_completed() were correct when the abstraction was=0A=
merged: at that time autoneg, link, and autoneg_complete were at bits=0A=
13, 14, and 15 of struct phy_device's first bitfield unit. Commit=0A=
2796ff1e3dca ("net: phy: add flag is_genphy_driven to struct phy_device")=
=0A=
later inserted is_genphy_driven just before autoneg, shifting the three=0A=
fields up by one, so the accessors now read:=0A=
=0A=
=A0 is_link_up()=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 reads bit 14 =3D autoneg=0A=
=A0 is_autoneg_enabled()=A0=A0 reads bit 13 =3D is_genphy_driven=0A=
=A0 is_autoneg_completed() reads bit 15 =3D link=0A=
=0A=
The official ax88796b Rust driver uses all three accessors in its=0A=
read_status() implementation, so it inherits the bug.=0A=
phy_attach_direct() sets is_genphy_driven only when it falls back to=0A=
the generic driver, and ax88796b has a real driver, so=0A=
is_genphy_driven stays 0. The broken is_autoneg_enabled() therefore=0A=
reads bit 13 as 0, compares it against AUTONEG_ENABLE (1), and always=0A=
returns false, so read_status() never reaches the=0A=
resolve_aneg_linkmode() call.=0A=
=0A=
The ordinary bindgen accessors take &self. Calling them through=0A=
(*phydev).link() would create a shared reference to the complete=0A=
bindings::phy_device, which is not appropriate for an object wrapped in=0A=
Opaque.=0A=
=0A=
Use the bindgen-generated raw accessors (link_raw(), autoneg_raw(),=0A=
and autoneg_complete_raw()) instead. They retain the bit positions and=0A=
endianness handling generated from the C layout without creating a Rust=0A=
reference to the complete phy_device. Drop the hand-written numbers=0A=
together with the TODO comment that marked them as a stopgap.=0A=
=0A=
The raw accessors are only emitted by bindgen 0.71 and later, and were=0A=
added at the Rust-for-Linux project's request, so this fix can only be=0A=
backported to stable branches whose minimum bindgen version is at least=0A=
that, hence the scope on the Cc: stable line below.=0A=
=0A=
Found by a static equivalence audit (C2RustDrv, a C-to-Rust driver=0A=
migration tool) that compares hand-written bitfield offsets against=0A=
the bindgen layout of struct phy_device. Verified by building the=0A=
bindings and checking the generated accessors; no runtime testing was=0A=
possible without PHY hardware.=0A=
=0A=
Fixes: 2796ff1e3dca ("net: phy: add flag is_genphy_driven to struct phy_dev=
ice")=0A=
Cc: stable@vger.kernel.org # Only 7.1.y and later (requires bindgen's raw p=
ointer accessors).=0A=
Link: https://github.com/rust-lang/rust-bindgen/issues/2674=0A=
Signed-off-by: Chunfeng Song <springbreeze@stu.pku.edu.cn>=0A=
Reviewed-by: FUJITA Tomonori <fujita.tomonori@gmail.com>=0A=
Link: https://patch.msgid.link/20260910055110.167110-1-springbreeze@stu.pku=
.edu.cn=0A=
Signed-off-by: Jakub Kicinski <kuba@kernel.org>=0A=
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>=0A=
---=0A=
=A0rust/kernel/net/phy.rs | 38 ++++++++++++++++++--------------------=0A=
=A01 file changed, 18 insertions(+), 20 deletions(-)=0A=
=0A=
diff --git a/rust/kernel/net/phy.rs b/rust/kernel/net/phy.rs=0A=
index 956cda573ddb..c4e7b1d6c6f4 100644=0A=
--- a/rust/kernel/net/phy.rs=0A=
+++ b/rust/kernel/net/phy.rs=0A=
@@ -123,39 +123,37 @@ pub fn state(&self) -> DeviceState {=0A=
=A0=A0=A0=A0 /// Gets the current link state.=0A=
=A0=A0=A0=A0 ///=0A=
=A0=A0=A0=A0 /// It returns true if the link is up.=0A=
+=A0=A0=A0 #[inline]=0A=
=A0=A0=A0=A0 pub fn is_link_up(&self) -> bool {=0A=
-=A0=A0=A0=A0=A0=A0=A0 const LINK_IS_UP: u64 =3D 1;=0A=
-=A0=A0=A0=A0=A0=A0=A0 // TODO: the code to access to the bit field will be=
 replaced with automatically=0A=
-=A0=A0=A0=A0=A0=A0=A0 // generated code by bindgen when it becomes possibl=
e.=0A=
-=A0=A0=A0=A0=A0=A0=A0 // SAFETY: The struct invariant ensures that we may =
access=0A=
-=A0=A0=A0=A0=A0=A0=A0 // this field without additional synchronization.=0A=
-=A0=A0=A0=A0=A0=A0=A0 let bit_field =3D unsafe { &(*self.0.get())._bitfiel=
d_1 };=0A=
-=A0=A0=A0=A0=A0=A0=A0 bit_field.get(14, 1) =3D=3D LINK_IS_UP=0A=
+=A0=A0=A0=A0=A0=A0=A0 let phydev =3D self.0.get().cast_const();=0A=
+=A0=A0=A0=A0=A0=A0=A0 // SAFETY: By the type invariant of `Device`, `phyde=
v` points to a valid=0A=
+=A0=A0=A0=A0=A0=A0=A0 // `struct phy_device`, and there is no concurrent w=
rite to this field.=0A=
+=A0=A0=A0=A0=A0=A0=A0 let link =3D unsafe { bindings::phy_device::link_raw=
(phydev) };=0A=
+=A0=A0=A0=A0=A0=A0=A0 link =3D=3D 1=0A=
=A0=A0=A0=A0 }=0A=
=A0=0A=
=A0=A0=A0=A0 /// Gets the current auto-negotiation configuration.=0A=
=A0=A0=A0=A0 ///=0A=
=A0=A0=A0=A0 /// It returns true if auto-negotiation is enabled.=0A=
+=A0=A0=A0 #[inline]=0A=
=A0=A0=A0=A0 pub fn is_autoneg_enabled(&self) -> bool {=0A=
-=A0=A0=A0=A0=A0=A0=A0 // TODO: the code to access to the bit field will be=
 replaced with automatically=0A=
-=A0=A0=A0=A0=A0=A0=A0 // generated code by bindgen when it becomes possibl=
e.=0A=
-=A0=A0=A0=A0=A0=A0=A0 // SAFETY: The struct invariant ensures that we may =
access=0A=
-=A0=A0=A0=A0=A0=A0=A0 // this field without additional synchronization.=0A=
-=A0=A0=A0=A0=A0=A0=A0 let bit_field =3D unsafe { &(*self.0.get())._bitfiel=
d_1 };=0A=
-=A0=A0=A0=A0=A0=A0=A0 bit_field.get(13, 1) =3D=3D u64::from(bindings::AUTO=
NEG_ENABLE)=0A=
+=A0=A0=A0=A0=A0=A0=A0 let phydev =3D self.0.get().cast_const();=0A=
+=A0=A0=A0=A0=A0=A0=A0 // SAFETY: By the type invariant of `Device`, `phyde=
v` points to a valid=0A=
+=A0=A0=A0=A0=A0=A0=A0 // `struct phy_device`, and there is no concurrent w=
rite to this field.=0A=
+=A0=A0=A0=A0=A0=A0=A0 let autoneg =3D unsafe { bindings::phy_device::auton=
eg_raw(phydev) };=0A=
+=A0=A0=A0=A0=A0=A0=A0 autoneg =3D=3D bindings::AUTONEG_ENABLE=0A=
=A0=A0=A0=A0 }=0A=
=A0=0A=
=A0=A0=A0=A0 /// Gets the current auto-negotiation state.=0A=
=A0=A0=A0=A0 ///=0A=
=A0=A0=A0=A0 /// It returns true if auto-negotiation is completed.=0A=
+=A0=A0=A0 #[inline]=0A=
=A0=A0=A0=A0 pub fn is_autoneg_completed(&self) -> bool {=0A=
-=A0=A0=A0=A0=A0=A0=A0 const AUTONEG_COMPLETED: u64 =3D 1;=0A=
-=A0=A0=A0=A0=A0=A0=A0 // TODO: the code to access to the bit field will be=
 replaced with automatically=0A=
-=A0=A0=A0=A0=A0=A0=A0 // generated code by bindgen when it becomes possibl=
e.=0A=
-=A0=A0=A0=A0=A0=A0=A0 // SAFETY: The struct invariant ensures that we may =
access=0A=
-=A0=A0=A0=A0=A0=A0=A0 // this field without additional synchronization.=0A=
-=A0=A0=A0=A0=A0=A0=A0 let bit_field =3D unsafe { &(*self.0.get())._bitfiel=
d_1 };=0A=
-=A0=A0=A0=A0=A0=A0=A0 bit_field.get(15, 1) =3D=3D AUTONEG_COMPLETED=0A=
+=A0=A0=A0=A0=A0=A0=A0 let phydev =3D self.0.get().cast_const();=0A=
+=A0=A0=A0=A0=A0=A0=A0 // SAFETY: By the type invariant of `Device`, `phyde=
v` points to a valid=0A=
+=A0=A0=A0=A0=A0=A0=A0 // `struct phy_device`, and there is no concurrent w=
rite to this field.=0A=
+=A0=A0=A0=A0=A0=A0=A0 let completed =3D unsafe { bindings::phy_device::aut=
oneg_complete_raw(phydev) };=0A=
+=A0=A0=A0=A0=A0=A0=A0 completed =3D=3D 1=0A=
=A0=A0=A0=A0 }=0A=
=A0=0A=
=A0=A0=A0=A0 /// Sets the speed of the PHY.=0A=
-- =0A=
2.55.0=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
