Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0609332EB4
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 13:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765892153; cv=none; b=sVvViR9FQub3qD9riugqISe2Wms/vHdIb4JkK2THRK22aF5tqzKW/kqlaChZBC0wZbfymtBfF5vqEekLuYFtj0IzXf3w1KLZyn4O+W7C8/Olc2VJVTt/0r7l9U/QkB6NnHUtn3x4FoE8Gcc0WqgcA5AHpLaV8K1Uk+aNtc7/214=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765892153; c=relaxed/simple;
	bh=0wZOep+vf42EUVGIqGI3k0Pa5hX7YqzN7oMbFAFNdJg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=h2bOZUPFKvW1OJX2GFBs7WU10lZWR8k1hjUGatPMNth2+Bdy6ge8u0kix5Dv1RkQWwt4W/b0Gq3inYems/nIhAHu5qxcqtSxlWjJSmom10nkwDNXDH1Y3Jh49tm/1sdaCxyNf1mh6XglA3V1qCbE9eKxNgAhZ9qfBCLyxhnO6ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eJ9JXItx; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eJ9JXItx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765892150; x=1797428150;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=0wZOep+vf42EUVGIqGI3k0Pa5hX7YqzN7oMbFAFNdJg=;
  b=eJ9JXItxenVlXthbdOpKpnVsK0/VBgUICOghP24KRprLC9JBgBSmXa1Q
   p2mBtFZhuPR3UqwQPKZb5bIqF1Fh99+dBttPlTZLOgghOU60oITJmLlKV
   nsZj56h+jA3hC01Hxs9+EQcv2pKIq35uI6B8hO1sXxuN3YMiOhSEW6/zv
   nNpFTrvrgyo3VlOXZ/1OBXmP9sJ0abdda3Lzg059SLQCrPP1YBuQBRa4Y
   oA62XbMINJqlp/ZT79aR5QdFagE1O9wmbN9nn61ZGo37X03TDdqWUlurH
   0cuQzqVSjgm4rTIyhILkLZxgKWjdLjbuB+R6aiTdWvXaFNRc56j52Ir0c
   g==;
X-CSE-ConnectionGUID: r4YKYmfSRJqe2ffW+CnGeg==
X-CSE-MsgGUID: Zr7fUNceQzqNlmOTxaxanw==
X-IronPort-AV: E=McAfee;i="6800,10657,11643"; a="71662915"
X-IronPort-AV: E=Sophos;i="6.21,153,1763452800"; 
   d="scan'208";a="71662915"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 05:35:49 -0800
X-CSE-ConnectionGUID: Ca5/tllxRES7zFidJ/1LAw==
X-CSE-MsgGUID: cPdGDVlTSMqZlWd2e/vxnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,153,1763452800"; 
   d="scan'208";a="197303392"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO [10.245.244.249]) ([10.245.244.249])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 05:35:47 -0800
Message-ID: <12329cbafe39d7db6f182676c5d96ba244fc4f73.camel@linux.intel.com>
Subject: Re: [PATCH 6.18 200/614] drm/xe: Enforce correct user fence
 signaling order using
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Matthew Brost <matthew.brost@intel.com>, Sasha
 Levin <sashal@kernel.org>
Date: Tue, 16 Dec 2025 14:35:44 +0100
In-Reply-To: <20251216111408.624748288@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
	 <20251216111408.624748288@linuxfoundation.org>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-2.fc41) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

Hi Folks,

This is an incorrect merge resolution followed by the patch already
been applied.

Please skip this patch.

Thanks,
Thomas


On Tue, 2025-12-16 at 12:09 +0100, Greg Kroah-Hartman wrote:
> 6.18-stable review patch.=C2=A0 If anyone has any objections, please let
> me know.
>=20
> ------------------
>=20
> From: Matthew Brost <matthew.brost@intel.com>
>=20
> [ Upstream commit adda4e855ab6409a3edaa585293f1f2069ab7299 ]
>=20
> Prevent application hangs caused by out-of-order fence signaling when
> user fences are attached. Use drm_syncobj (via dma-fence-chain) to
> guarantee that each user fence signals in order, regardless of the
> signaling order of the attached fences. Ensure user fence writebacks
> to
> user space occur in the correct sequence.
>=20
> v7:
> =C2=A0- Skip drm_syncbj create of error (CI)
>=20
> Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel
> GPUs")
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> Reviewed-by: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> Link:
> https://patch.msgid.link/20251031234050.3043507-2-matthew.brost@intel.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> =C2=A0drivers/gpu/drm/xe/xe_exec_queue.c | 3 +++
> =C2=A01 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/xe/xe_exec_queue.c
> b/drivers/gpu/drm/xe/xe_exec_queue.c
> index cb5f204c08ed6..a6efe4e8ab556 100644
> --- a/drivers/gpu/drm/xe/xe_exec_queue.c
> +++ b/drivers/gpu/drm/xe/xe_exec_queue.c
> @@ -344,6 +344,9 @@ void xe_exec_queue_destroy(struct kref *ref)
> =C2=A0	struct xe_exec_queue *q =3D container_of(ref, struct
> xe_exec_queue, refcount);
> =C2=A0	struct xe_exec_queue *eq, *next;
> =C2=A0
> +	if (q->ufence_syncobj)
> +		drm_syncobj_put(q->ufence_syncobj);
> +
> =C2=A0	if (q->ufence_syncobj)
> =C2=A0		drm_syncobj_put(q->ufence_syncobj);
> =C2=A0

