Received: from ms.puri.sm (ms.puri.sm [135.181.196.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E043336682A
	for <patches@lists.linux.dev>; Wed, 11 Mar 2026 00:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=135.181.196.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773189862; cv=none; b=nhC4MkUWomZvxTgBewLhtCy/C5jzX9d7OvhOMuP6AWJ1VxLMiS6GhAbabknb3POYjan4QmOzOx2C5wQd9ehJ/ZipuB9wRV+tQxJdJOxZ5PXsou1d1NniFP7Lj1VvM7N6HyIaK6fxUIQVmUezhSictisCVls5EN87LU306MP4Qpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773189862; c=relaxed/simple;
	bh=bl7aXsWttulR8Cj9N7B+7S2072TKIJYXR4BxhG3BRmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=njut39re3zw1HHjB0Wd39JJuXedxks7uAEIvXY6XGHIxDFk50NTv7PHVbJoMvvcbIToE74OrrUrtrauB/SnAhgudq1brHh0w+0SkFq6sx4jOa9JuAxTJYFZXmxAWGa88f+Y4G5x0BQdvWGa2mccDmYw4S/W5TMLWIKh/T+LxLe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=puri.sm; spf=pass smtp.mailfrom=puri.sm; dkim=pass (2048-bit key) header.d=puri.sm header.i=@puri.sm header.b=Q44lxkV1; arc=none smtp.client-ip=135.181.196.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=puri.sm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=puri.sm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=puri.sm header.i=@puri.sm header.b="Q44lxkV1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=puri.sm; s=smtp2;
	t=1773189409; bh=bl7aXsWttulR8Cj9N7B+7S2072TKIJYXR4BxhG3BRmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q44lxkV1hFko2QSoGWhr/JHXJ0nCjUwA3bfWzm0kQRoGvtkeQjd7COfDT1p1BFhkK
	 GURdpCccmsGxQ8UR7iRt/55CvabPG5XIDsF8s97Lu5ADAScDPyUuTRSelGSTnNS4Kl
	 kknccI6z1uKNXtlDWpFD0LiRi85yTcqwfp2ElLKyhr/0JB0Nq2BpgwhTktiiJ6Pw29
	 oZTmz4EZLx3RFs0F+qIVREECEWsVwqjyBN5aKXZIHo3ZX9aHX0TI6G4mOAkqHEfAYi
	 q1ppK5FgdW7VBlodMw+j744Q1DITWPbx5Sn25nsfXJ09mJaMRjDBu5DwjnaXoVqd/Q
	 AFkj6ePnf2I7g==
Received: from pliszka.localnet (83.24.17.124.ipv4.supernova.orange.pl [83.24.17.124])
	by ms.puri.sm (Postfix) with ESMTPSA id D61711F7B1;
	Tue, 10 Mar 2026 17:36:48 -0700 (PDT)
From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
To: patches@lists.linux.dev, stable@vger.kernel.org,
 Sasha Levin <sashal@kernel.org>
Cc: Ming Qian <ming.qian@oss.nxp.com>, Frank Li <Frank.Li@nxp.com>,
 Nicolas Dufresne <nicolas.dufresne@collabora.com>,
 Hans Verkuil <hverkuil+cisco@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject:
 Re: [PATCH 6.18 085/314] media: verisilicon: Avoid G2 bus error while
 decoding H.264 and HEVC
Date: Wed, 11 Mar 2026 01:36:46 +0100
Message-ID: <6892707.LvFx2qVVIh@pliszka>
In-Reply-To:
 <3b92b74f68817accc3efa8756ab3ee6bd91cefc6.1773141555.git.sashal@kernel.org>
References:
 <cover.1773141554.git.sashal@kernel.org>
 <3b92b74f68817accc3efa8756ab3ee6bd91cefc6.1773141555.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On wtorek, 10 marca 2026 12:15:44 czas =C5=9Brodkowoeuropejski standardowy =
Sasha=20
Levin wrote:
> From: Ming Qian <ming.qian@oss.nxp.com>
>=20
> [ Upstream commit e0203ddf9af7c8e170e1e99ce83b4dc07f0cd765 ]
>=20
> For the i.MX8MQ platform, there is a hardware limitation: the g1 VPU and
> g2 VPU cannot decode simultaneously; otherwise, it will cause below bus
> error and produce corrupted pictures, even potentially lead to system han=
g.
>=20
> [  110.527986] hantro-vpu 38310000.video-codec: frame decode timed out.
> [  110.583517] hantro-vpu 38310000.video-codec: bus error detected.
>=20
> Therefore, it is necessary to ensure that g1 and g2 operate alternately.
> This allows for successful multi-instance decoding of H.264 and HEVC.
>=20
> To achieve this, g1 and g2 share the same v4l2_m2m_dev, and then the
> v4l2_m2m_dev can handle the scheduling.
>=20
> Fixes: cb5dd5a0fa518 ("media: hantro: Introduce G2/HEVC decoder")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
> Reviewed-by: Frank Li <Frank.Li@nxp.com>
> Co-developed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/media/platform/verisilicon/hantro.h   |  2 +
>  .../media/platform/verisilicon/hantro_drv.c   | 42 +++++++++++++++++--
>  .../media/platform/verisilicon/imx8m_vpu_hw.c |  8 ++++
>  3 files changed, 49 insertions(+), 3 deletions(-)
>=20

This one introduces a regression that's being fixed in https://lore.kernel.=
org/
lkml/20260306031059.801-1-ming.qian@oss.nxp.com/T/, so they should probably=
 be=20
applied together once the fix lands.


