Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804ED2178E8
	for <patches@lists.linux.dev>; Fri,  4 Oct 2024 14:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728052586; cv=none; b=cAz7I+6pqSmqkKBDea7pOVrI/w5Pf+VRrhZYXl0Tyy8moUlWkLbkdgrN0svUoaQfVrnWq1FwiM8TIrRBY5qo/GnKMB7zJu8k4zf/dNEbJj8Z5k3dYOVSNvuw3sXXUFktIOABt8EANW7Ez23+HLKziZBf/4BoGJEjm7JurvHa0Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728052586; c=relaxed/simple;
	bh=ypgM0rMAhUSBydVvXU3z4ADwOwbDQ9Xnmw411GjBYbI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=K6xI8HR8CwOWlVef1VuUZ//Muw+6/zVtQVmlgNpn2EcbxUcQIZ9ODVtgSBDQQyzmHP67acMxO460zSvidEw82YzQ4rK85iXiisfrDu/Klmu0Yfog8AjNJzGEWiX/eUjk988IXDsdJU2lZcmdSOeQDPn7p7eYg3pRLoW/9vKuOlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KK1JULKs; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KK1JULKs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728052585; x=1759588585;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ypgM0rMAhUSBydVvXU3z4ADwOwbDQ9Xnmw411GjBYbI=;
  b=KK1JULKs1qXyC/JuFDJBCqx+xaQN2e6lcL2uoFe6oIpnl6oa9UUDJiXQ
   He+VZKELA4ZjUsyQue/LvetJacmanEinYj/bf/ICvAcR3o4C1JapsRxeu
   b9W2CGg7Z7lVpm7MPJa0e5cGNY+cS9S1VjbvQbNCMYBCnKAcZlQ+q2wkT
   TEFuZyMgcRYoNF/0RkRD42BjYQvpXteeVv53l5wDOH3WmJgMhwVRe4iFi
   WoPbUoPimkAapNde6U6C8fw0Wkk5aIoqp0rifN8XSIik0TZ6AjVXx8UiB
   oiUDsVyIlyxSGQjJP8utPsoolxqFLl81WAZ54BwU/O97201Zd89tb89Xq
   A==;
X-CSE-ConnectionGUID: /d1YYHQpTd6erdKQqcKJYg==
X-CSE-MsgGUID: FLpLGSTiQTiRbM9bDf3mOg==
X-IronPort-AV: E=McAfee;i="6700,10204,11215"; a="27452128"
X-IronPort-AV: E=Sophos;i="6.11,177,1725346800"; 
   d="scan'208";a="27452128"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2024 07:36:25 -0700
X-CSE-ConnectionGUID: qlQWfaiCQWWmay+C56UFpw==
X-CSE-MsgGUID: WhS2pgbeRIuuTIOZ1IwwHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,177,1725346800"; 
   d="scan'208";a="74392671"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2024 07:36:25 -0700
Received: from abityuts-desk1.fi.intel.com (abityuts-desk1.fi.intel.com [10.237.68.150])
	by linux.intel.com (Postfix) with ESMTP id 7A42420B5782;
	Fri,  4 Oct 2024 07:36:23 -0700 (PDT)
Message-ID: <eae9f1028fd9f63a280154422e370b90380d40a6.camel@linux.intel.com>
Subject: Re: [PATCH 6.11 608/695] intel_idle: add Granite Rapids Xeon support
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Fri, 04 Oct 2024 17:36:22 +0300
In-Reply-To: <5a0d003078c7cb5aa5196c2dcf0508996ff88fcc.camel@linux.intel.com>
References: <20241002125822.467776898@linuxfoundation.org>
	 <20241002125846.785351246@linuxfoundation.org>
	 <5a0d003078c7cb5aa5196c2dcf0508996ff88fcc.camel@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 (3.52.3-1.fc40) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2024-10-04 at 12:14 +0300, Artem Bityutskiy wrote:
> On Wed, 2024-10-02 at 15:00 +0200, Greg Kroah-Hartman wrote:
> > 6.11-stable review patch.=C2=A0 If anyone has any objections, please le=
t me know.
> >=20
> > ------------------
> >=20
> > From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> >=20
> > commit 370406bf5738dade8ac95a2ee95c29299d4ac902 upstream.
> >=20
> > Add Granite Rapids Xeon C-states, which are C1, C1E, C6, and C6P.
> >=20
> ... snip ...
>=20
> Hi Greg, I was on vacation. Looks good, but I'll test 6.11-stable with th=
ese
> patches (#608 and #609) to double check, and let you know if there are is=
sues.

Applied the 2 patches (#608 and #609) on top of v6.11.1, built, booted on
Granite Rapids Xeon, all C-states are available and enabled by default, as
expected.

Thanks.
